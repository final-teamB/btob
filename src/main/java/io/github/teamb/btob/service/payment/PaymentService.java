package io.github.teamb.btob.service.payment;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.jaxb.SpringDataJaxb.OrderDto;
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
import io.github.teamb.btob.dto.order.OrderDTO;
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
		int orderId = payment.getOrderId();
		int amount = payment.getAmount();
		String paymentKey = payment.getPaymentKey();
		
	    // 1. [검증] DB 금액과 요청 금액 비교
	    PaymentViewDTO orderInfo = paymentMapper.getPaymentViewInfo(orderNo);
	    if (orderInfo == null || orderInfo.getTotalPrice() != amount) {
	        throw new Exception("금액 불일치: 보안 위험이 감지되었습니다.");
	    }

	    // 2. [API 호출 준비]
	    RestTemplate restTemplate = new RestTemplate();
	    String authorizations = Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));

	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "Basic " + authorizations);
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    // JSONObject 대신 Map 사용 (의존성 추가 없음)
	    Map<String, Object> params = new HashMap<>();
	    params.put("paymentKey", paymentKey);
	    params.put("orderId", orderNo);
	    params.put("amount", amount);

	    HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);

	    // 3. [승인 요청]
	    // v2 SDK 응답도 이 엔드포인트를 통해 승인됩니다.
	    ResponseEntity<Map> response = restTemplate.postForEntity(
	        "https://api.tosspayments.com/v1/payments/confirm", 
	        entity, 
	        Map.class
	    );

	    if (response.getStatusCode() == HttpStatus.OK) {
	        Map<String, Object> body = response.getBody();
	        String method = (String) body.get("method");
	        
	        String systemId = "PAYMENT";
	        String nextStatus = "pm002";
	        
	        // 2. [결제 번호 생성] DB 시퀀스나 별도 로직으로 결제용 PK 생성
	        String paymentNo = paymentMapper.selectFormattedPaymentNo(systemId, loginUserId); 
	        		
    		// 3. 결제 전용 마스터 테이블(TB_PAYMENT_MST) 저장
    		// 워크플로우 외에 결제 키(paymentKey) 등 상세 정보 저장이 필요할 때 수행
    		payment.setPaymentNo(paymentNo);
	        payment.setMethod(method);
	        payment.setStatus(nextStatus);
	        payment.setRegId(loginUserId);
	        paymentMapper.insertPaymentMst(payment);
	        
	        Integer generatedPaymentId = payment.getPaymentId();
	        		
	        ApprovalDecisionRequestDTO payApproval = new ApprovalDecisionRequestDTO();
	        payApproval.setSystemId(systemId);      
		    payApproval.setRefId(generatedPaymentId); 
		    payApproval.setApprovalStatus("COMPLETE");
		    payApproval.setRequestEtpStatus(nextStatus);
		    payApproval.setApprUserNo(loginUserNo);
		    payApproval.setRequestUserNo(loginUserNo);
	        
		    bizWorkflowService.modifyEtpStatusAndLogHist(payApproval);
	       
	      
		    
		    ApprovalDecisionRequestDTO orderApproval = new ApprovalDecisionRequestDTO();
		    orderApproval.setSystemId("ORDER");      
		    orderApproval.setRefId(payment.getOrderId()); // 주문 PK
		    orderApproval.setApprovalStatus("COMPLETE");
		    orderApproval.setRequestEtpStatus(nextStatus);
		    orderApproval.setApprUserNo(loginUserNo);
		    orderApproval.setRequestUserNo(loginUserNo);
		    
		    bizWorkflowService.modifyEtpStatusAndLogHist(orderApproval);
		    
            // 3. [상태 확인] 이미 pm002이므로, 마스터 테이블에도 해당 상태를 함께 기록
		    Map<String, Object> cartParams = new HashMap<>();
            cartParams.put("orderNo", orderNo);    // 새로 생성된 주문번호
            cartParams.put("userId", loginUserId); // 로그인한 유저 ID
            cartParams.put("status", "ORDERED");       // '요청' 상태로 변경
            cartParams.put("useYn", "N");       // 'N' 상태로 변경
            
            cartMapper.updateCartOrderInfo(cartParams);
          
	    }
	}


	public PaymentViewDTO getPaymentViewInfo(String orderNo) {
		return paymentMapper.getPaymentViewInfo(orderNo);
	}

}
