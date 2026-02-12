package io.github.teamb.btob.service.payment;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentViewDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.mapper.payment.PaymentMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class PaymentService {
	private final PaymentMapper paymentMapper;
	private final OrderMapper orderMapper;
	private final CartMapper cartMapper;
	private final BizWorkflowService bizWorkflowService; // 공통 워크플로우 서비스
	private final LoginUserProvider loginUserProvider;

	@Value("${toss.secret-key}")
    private String secretKey;
	
	
	public void confirmPayment(PaymentRequestDTO payment) throws Exception {
	    Integer loginUserNo = loginUserProvider.getLoginUserNo();
	    String loginUserId = loginUserProvider.getLoginUserId(); 
	    if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");
	    
	    String orderNo = payment.getOrderNo();
	    int amount = payment.getAmount();
	    String paymentKey = payment.getPaymentKey();
	    String payStep = payment.getPayStep();
	    String tossOrderId = payment.getTossOrderId();
	    
	    // 1. [검증] 주문 정보 확인
	    PaymentViewDTO orderInfo = paymentMapper.getPaymentViewInfo(orderNo);
	    if (orderInfo == null) throw new Exception("주문 정보를 찾을 수 없습니다.");

	    // 2. [API 호출 준비]
	    RestTemplate restTemplate = new RestTemplate();
	    String authorizations = Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "Basic " + authorizations);
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, Object> params = new HashMap<>();
	    params.put("paymentKey", paymentKey);
	    params.put("orderId", tossOrderId);
	    params.put("amount", amount);

	    HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);

	    // 3. [승인 요청]
	    ResponseEntity<Map> response = null;
	    try {
	        response = restTemplate.postForEntity("https://api.tosspayments.com/v1/payments/confirm", entity, Map.class);
	    } catch (Exception e) {
	        throw new Exception("토스 승인 요청 중 네트워크 오류가 발생했습니다: " + e.getMessage());
	    }

	    // 4. [승인 성공 후 DB 처리]
	    if (response.getStatusCode() == HttpStatus.OK) {
	        Map<String, Object> body = response.getBody();
	        
	        try {
	            // --- 이 안에서 에러가 나면 무조건 결제 취소 API를 호출합니다 ---
	            String method = (String) body.get("method");
	            String systemId = "PAYMENT";
	            String nextStatus = "FIRST".equals(payStep) ? "pm002" : "pm004";
	            
	            String paymentNo = paymentMapper.selectFormattedPaymentNo(systemId, loginUserId); 
	            System.out.println(">>> [INSERT 전] paymentId: " + payment.getPaymentId());
	            payment.setPaymentNo(paymentNo);
	            payment.setMethod(method);
	            payment.setStatus(nextStatus);
	            payment.setRegId(loginUserId);
	            payment.setDbOrderId(Integer.parseInt(String.valueOf(orderInfo.getOrderId())));
	            paymentMapper.insertPaymentMst(payment); // ⭐️ DB 저장 1
	            
	           
	            if (payment.getPaymentId() == null || payment.getPaymentId() == 0) {
	                throw new Exception("CRITICAL: DB에서 생성된 ID(PK)를 가져오지 못했습니다. 매퍼 설정을 확인하세요.");
	            }
	            
	            Integer generatedPaymentId = payment.getPaymentId();
	            
	            // 워크플로우 처리
	            ApprovalDecisionRequestDTO payApproval = new ApprovalDecisionRequestDTO();
	            payApproval.setSystemId(systemId);      
	            payApproval.setRefId(generatedPaymentId); 
	            payApproval.setApprovalStatus("COMPLETE");
	            payApproval.setRequestEtpStatus(nextStatus);
	            payApproval.setApprUserNo(loginUserId);
	            payApproval.setRequestUserNo(loginUserId);
	            payApproval.setUserId(loginUserId);
	            bizWorkflowService.modifyEtpStatusAndLogHist(payApproval); // ⭐️ DB 저장 2

	            ApprovalDecisionRequestDTO orderApproval = new ApprovalDecisionRequestDTO();
	            orderApproval.setSystemId("ORDER");      
	            orderApproval.setRefId(payment.getDbOrderId());
	            orderApproval.setApprovalStatus("COMPLETE");
	            orderApproval.setRequestEtpStatus(nextStatus);
	            orderApproval.setApprUserNo(loginUserId);
	            orderApproval.setRequestUserNo(loginUserId);
	            orderApproval.setUserId(loginUserId);
	            bizWorkflowService.modifyEtpStatusAndLogHist(orderApproval); // ⭐️ DB 저장 3

	            // 장바구니 업데이트
	            Map<String, Object> cartParams = new HashMap<>();
	            cartParams.put("orderNo", orderNo);
	            cartParams.put("userId", loginUserId);
	            cartParams.put("status", "ORDERED");
	            cartParams.put("useYn", "N");
	            cartMapper.updateCartOrderInfo(cartParams); // ⭐️ DB 저장 4

	        } catch (Exception e) {
	            // 🚨 DB 처리 중 하나라도 에러 발생 시 토스 결제 취소 실행
	            rollbackTossPayment(paymentKey, "서버 내부 오류로 인한 자동 취소: " + e.getMessage());
	            throw new Exception("결제 승인은 되었으나 처리 중 오류가 발생하여 자동 취소되었습니다. 다시 시도해주세요.");
	        }
	    }
	}

	// 🔄 취소 로직 전용 메서드 추가
	private void rollbackTossPayment(String paymentKey, String cancelReason) {
	    try {
	        RestTemplate restTemplate = new RestTemplate();
	        String authorizations = Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));
	        HttpHeaders headers = new HttpHeaders();
	        headers.set("Authorization", "Basic " + authorizations);
	        headers.setContentType(MediaType.APPLICATION_JSON);

	        Map<String, Object> params = new HashMap<>();
	        params.put("cancelReason", cancelReason);

	        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);
	        restTemplate.postForEntity("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel", entity, Map.class);
	    } catch (Exception e) {
	        // 취소 실패 시 로그를 남기고 관리자가 수동 처리하게 해야 함
	        System.err.println("CRITICAL: 결제 자동 취소 실패 - " + paymentKey + " / 사유: " + e.getMessage());
	    }
	}

	public PaymentViewDTO getPaymentViewInfo(String orderNo) {
		return paymentMapper.getPaymentViewInfo(orderNo);
	}

}
