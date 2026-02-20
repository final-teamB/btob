package io.github.teamb.btob.service.payment;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryStatus;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.document.DocumentInsertDTO;
import io.github.teamb.btob.dto.order.OrderVoDTO;
import io.github.teamb.btob.dto.payment.PaymentRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentViewDTO;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.document.TradeDocMapper;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.mapper.payment.PaymentMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import io.github.teamb.btob.service.adminDelivery.DeliveryService;
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
	private final DeliveryMapper deliveryMapper;
	private final TradeDocMapper tradeDocMapper;
	@Autowired
    @Lazy
    private DeliveryService deliveryService;

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
	    PaymentViewDTO orderInfo;
	    if ("SECOND".equals(payStep)) {
	        // 2차 결제일 때는 2차 전용 조회 메서드 사용
	        orderInfo = paymentMapper.getPaymentSecondViewInfo(orderNo);
	    } else {
	        // 1차 결제일 때는 기존 메서드 사용
	        orderInfo = paymentMapper.getPaymentViewInfo(orderNo);
	    }
	    
	    if (orderInfo == null) {
	        throw new Exception(payStep + " 결제 단계에 대한 주문 정보를 찾을 수 없습니다. (주문번호: " + orderNo + ")");
	    }

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
	            
	            // 1. 로그를 찍어보세요 (데이터가 잘 오는지 확인)
	            System.out.println("DEBUG: orderInfo.getOrderId() 값 -> " + orderInfo.getOrderId());
	            System.out.println("DEBUG: payStep 값 -> " + payStep);

	            // 2. 타입을 안전하게 변환 (가장 안전한 방법)
	            int dbOrderId = Integer.parseInt(String.valueOf(orderInfo.getOrderId()));

	            payment.setDbOrderId(dbOrderId);
	            payment.setMethod(method);
	            payment.setPaymentKey(paymentKey);
	            payment.setStatus("DONE");
	          	            	           
	            if ("SECOND".equals(payStep)) {
	                // 2차 결제일 때는 update 문 실행
	                payment.setUpdId(loginUserId);
	                paymentMapper.updatePaymentForSecondStep(payment); 
	            } else {
	            	String paymentNo = paymentMapper.selectFormattedPaymentNo(systemId, loginUserId); 
	            	
	            	payment.setPaymentNo(paymentNo);
	                payment.setPayStep(payStep);
	            	payment.setRegId(loginUserId);
	            	payment.setDbOrderId(Integer.parseInt(String.valueOf(orderInfo.getOrderId())));
	                // 1차 결제일 때만 기존처럼 insert
	                paymentMapper.insertPaymentMst(payment); 
	            }
	    
	            ApprovalDecisionRequestDTO orderApproval = new ApprovalDecisionRequestDTO();
	            orderApproval.setSystemId("ORDER");      
	            orderApproval.setRefId(payment.getDbOrderId());
	            orderApproval.setApprovalStatus("COMPLETE");
	            orderApproval.setRequestEtpStatus(nextStatus);
	            orderApproval.setApprUserNo("");
	            orderApproval.setRequestUserNo(loginUserId);
	            orderApproval.setUserId(loginUserId);
	            bizWorkflowService.modifyEtpStatusAndLogHist(orderApproval); // ⭐️ DB 저장 3
	            
	            // 거래내역서 생성
	            if ("pm004".equals(nextStatus)) {
	    	        try {
	    	        	Integer firstAmount = paymentMapper.selectFirstPaymentAmount(dbOrderId); 
	    	            if (firstAmount == null) firstAmount = 0;

	    	            // 2. 현재 승인된 2차 결제 금액(amount)과 합산
	    	            int totalAmount = firstAmount + amount;
	    	        	
	    	            // 1. 문서 번호 생성 (PO-회사코드-날짜-순번)
	    	            String docNo = tradeDocMapper.selectFormattedDocNo("TR", loginUserId);
	    	            
	    	            // 2. DTO 객체 생성 및 데이터 빌드
	    	            DocumentInsertDTO docDto = new DocumentInsertDTO();
	    	            
	    	            docDto.setDocNo(docNo);
	    	            docDto.setDocType("TRANSACTION");
	    	            
	    	            // [선택하신 제목 형식] [주문번호] 물품 공급 발주서
	    	            docDto.setDocTitle("[" + orderNo + "] 물품 공급 거래명세서");
	    	            
	    	            docDto.setOrderId(dbOrderId);
	    	            docDto.setOwnerUserId(loginUserId); // 문서를 조회할 권한을 가진 유저(발주자)
	    	            
	    	            docDto.setTotalAmt(totalAmount);
	    	            docDto.setRegId(loginUserId);
	    	            
	    	            // 3. Mapper 호출 (TB_DOCUMENT_MST에 최종 인서트)
	    	            tradeDocMapper.insertDocument(docDto);
	    	            
	    	            System.out.println("거래명세서 생성 완료: " + docNo);
	    	            
	    	        } catch (Exception e) {
	    	            // 예외 로그 남기기 (필요 시 RuntimeException으로 던져 트랜잭션 롤백)
	    	            System.err.println("거래명세서(TR) 자동 생성 중 오류 발생: " + e.getMessage());
	    	            e.printStackTrace();
	    	        }
	    	    }
	            
	            // 1차 결제 완료 -> 배송 생성
	            if ("pm002".equals(nextStatus)) {

	                DeliveryDTO delivery = deliveryMapper.selectDeliveryJoinOrder(payment.getDbOrderId());

	                if (delivery == null) {
	                    DeliveryDTO newDelivery = new DeliveryDTO();
	                    newDelivery.setOrderId(payment.getDbOrderId());
	                    newDelivery.setDeliveryStatus(DeliveryStatus.dv001); // 상품준비중
	                    newDelivery.setRegId(loginUserId);

	                    deliveryMapper.insertDelivery(newDelivery);
	                }
	            }
	            // 2차 결제 완료 -> 배송상태 dv006으로 변경
	            else if ("pm004".equals(nextStatus)) {
	                try {
	                    DeliveryDTO delivery = deliveryMapper.selectDeliveryJoinOrder(payment.getDbOrderId());
	                    if (delivery != null) {
	                        // 중요: modifyDelivery 내부 로직이 복잡하므로, 
	                        // 여기서는 상태 코드만 명확히 세팅해서 넘깁니다.
	                        delivery.setUpdId(loginUserId);
	                        delivery.setDeliveryStatus(DeliveryStatus.dv006); 
	                        
	                        // 만약 modifyDelivery에서 에러가 난다면, 
	                        // 결제 전체를 롤백할 것인지 결정해야 합니다.
	                        // 일단은 배송 상태 변경 실패가 결제 취소로 이어지지 않게 별도 try-catch 권장
	                        // 운송장 번호 생성, 택배사 지정, dv006 변경, 이력 등록, 알림 발송
	                        deliveryService.modifyDelivery(delivery);
	                    }
	                } catch (Exception de) {
	                    // 배송 상태 변경 실패 시 로그만 남기고 결제는 유지하고 싶다면 여기서 catch
	                    System.err.println("🚨 배송 상태 변경 중 오류 발생 (결제는 성공): " + de.getMessage());
	                    // 만약 배송 상태 변경 실패 시 결제도 취소해야 한다면 throw de; 를 하시면 됩니다.
	                }
	            }
	            
	            // 장바구니 업데이트
	            if ("FIRST".equals(payStep)) {
	                Map<String, Object> cartParams = new HashMap<>();
	                cartParams.put("orderNo", orderNo);
	                cartParams.put("userId", loginUserId);
	                cartParams.put("status", "ORDERED");
	                cartParams.put("useYn", "N");
	                cartMapper.updateCartPayment(cartParams);
	            }

	        } catch (Exception e) {
	            // 🚨 DB 처리 중 하나라도 에러 발생 시 토스 결제 취소 실행
	            rollbackTossPayment(paymentKey, "서버 내부 오류로 인한 자동 취소: " + e.getMessage());
	            throw new Exception("결제 승인은 되었으나 처리 중 오류가 발생하여 자동 취소되었습니다. 다시 시도해주세요.");
	        }
	    }
	}
	
	/**
	 * 배송 상태가 dv005(통관완료)일 때 호출되어 2차 결제를 준비함
	 */
	public void prepareSecondPayment(int orderId, String adminId) throws Exception {
		OrderVoDTO orderInfo = orderMapper.getOrderBasicInfoForPayment(orderId);
		if (orderInfo == null) throw new Exception("존재하지 않는 주문입니다: " + orderId);
		
		
	    // 1. 주문 정보 조회 (orderId를 가져오기 위함)
	    String orderNo = orderInfo.getOrderNo();
	    String userId = orderInfo.getRegId();
	    int userNo = orderInfo.getUserNo();
	    String payStep = "SECOND";
	    
	    // 2. 유류 거래 특화 하드코딩 금액 (현실감 있는 수치)
	    final int OIL_TAX = 5500000;       // 유류세
	    final int IMPORT_DUTY = 1200000;    // 관세
	    final int STORAGE_FEE = 300000;     // 저유소 보관료
	    final int TRANSPORT_FEE = 500000;   // 탱크로리 운송비
	    
	    int totalAmount = OIL_TAX + IMPORT_DUTY + STORAGE_FEE + TRANSPORT_FEE;

	    // 3. 2차 결제 객체 생성
	    PaymentRequestDTO secondPay = new PaymentRequestDTO();
	    secondPay.setOrderNo(orderNo);
	    secondPay.setDbOrderId(orderId); // ⭐️ 외래키 설정
	    secondPay.setAmount(totalAmount);
	    secondPay.setPayStep(payStep);
	    secondPay.setStatus("READY");      // 2차 결제 대기 상태
	    secondPay.setRegId(userId);
	    
	    // 결제 번호 생성
	    String systemId = "PAYMENT";
	    String paymentNo = paymentMapper.selectFormattedPaymentNo(systemId, secondPay.getRegId());
	    secondPay.setPaymentNo(paymentNo);

	    // 4. DB INSERT (새로운 결제 행 추가)
	    paymentMapper.insertPaymentMst(secondPay);

	    // 4. 주문 워크플로우를 pm003(2차결제요청)으로 변경
	    ApprovalDecisionRequestDTO orderApproval = new ApprovalDecisionRequestDTO();
	    orderApproval.setSystemId("ORDER");      
	    orderApproval.setRefId(secondPay.getDbOrderId());
	    orderApproval.setApprovalStatus("COMPLETE");
	    orderApproval.setRequestEtpStatus("pm003"); // 2차결제요청 상태
	    orderApproval.setUserId(userId);
	    orderApproval.setApprUserNo(adminId);
	    orderApproval.setRequestUserNo(userId);
	    
	    bizWorkflowService.modifyEtpStatusAndLogHist(orderApproval);
	  
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

	public PaymentViewDTO getPaymentSecondViewInfo(String orderNo) {
		return paymentMapper.getPaymentSecondViewInfo(orderNo);
	}

}
