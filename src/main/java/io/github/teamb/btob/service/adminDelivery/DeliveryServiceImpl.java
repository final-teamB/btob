package io.github.teamb.btob.service.adminDelivery;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Spring 트랜잭션 권장

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryHistoryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryStatus;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import io.github.teamb.btob.service.notification.NotificationService;
import io.github.teamb.btob.service.payment.PaymentService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeliveryServiceImpl implements DeliveryService {
	
	private final DeliveryMapper deliveryMapper;
	private final NotificationService notificationService;
	private final PaymentService paymentService;
	private final LoginUserProvider loginUserProvider;

	// 전체 배송 목록 조회 (관리자용)
	@Override
	public List<DeliveryDTO> getDeliveryList(DeliveryDTO deliveryDTO) {
		
		return deliveryMapper.selectDeliveryList(deliveryDTO);
	}

	// 배송 정보 상세보기
	@Override
	public DeliveryDTO getDeliveryDetail(int deliveryId) {
		
		return deliveryMapper.selectDeliveryDetail(deliveryId);
	}

	// 통합 수정 (수정, 주문 상태 동기화, 배송이력 등록)
	@Override
	@Transactional
    public void modifyDelivery(DeliveryDTO deliveryDTO) {
		
		// 이전 데이터 조회
		DeliveryDTO oldData = deliveryMapper.selectDeliveryDetail(deliveryDTO.getDeliveryId());
		if (oldData == null) {
	        throw new IllegalArgumentException("존재하지 않는 배송 정보입니다.");
	    }
		
		// 화면에서 orderId가 안 넘어왔을 경우를 대비해 DB 데이터로 채워줌
	    if (deliveryDTO.getOrderId() == 0) {
	        deliveryDTO.setOrderId(oldData.getOrderId());
	        System.out.println("DB에서 복구된 OrderID: " + deliveryDTO.getOrderId());
	    }
		
		// 주문상태에 따른 배송상태 변경 권환
		String orderStatus = deliveryMapper.getOrderStatusByOrderId(deliveryDTO.getDeliveryId());
		DeliveryStatus newDeliveryStatus = deliveryDTO.getDeliveryStatus();
		
		System.out.println("=== DEBUG ===");
		System.out.println("orderStatus = [" + orderStatus + "]");
		System.out.println("newDeliveryStatus = [" + newDeliveryStatus + "]");
		System.out.println("newDeliveryStatus.name() = [" + 
		    (newDeliveryStatus != null ? newDeliveryStatus.name() : "null") + "]");
		System.out.println("================");
		
		if (newDeliveryStatus != null && orderStatus != null) {
		    String statusCode = newDeliveryStatus.name();

		    Map<String, List<String>> rule = Map.of(
		        "pm002", List.of("dv001","dv002","dv003","dv004","dv005"),
		        "pm004", List.of("dv006","dv007")
		    );

		    List<String> allowed = rule.get(orderStatus);
		    if (allowed != null && !allowed.contains(statusCode)) {
		        throw new IllegalArgumentException("유효하지 않은 배송 상태 변경입니다.");
		    }
		}

		
        // 배송 정보 업데이트 
        deliveryMapper.updateDelivery(deliveryDTO);
        System.out.println("DTO OrderID: " + deliveryDTO.getOrderId());
        // 2차 결제 생성 로직 추가
		DeliveryStatus newStatus = deliveryDTO.getDeliveryStatus();
		String adminId = loginUserProvider.getLoginUserId();        
	        // 상태가 '통관완료(dv005)'로 바뀌었을 때만 실행
	        if (newStatus != null && "dv005".equals(newStatus.name())) {
	            int orderId = deliveryDTO.getOrderId(); 
	            if (orderId <= 0) {
	                throw new RuntimeException("해당 배송 정보에 연결된 주문 ID가 없습니다.");
	            }
	            try {
	                paymentService.prepareSecondPayment(orderId, adminId);
	            } catch (Exception e) {
	                // 트랜잭션 처리가 되어 있으므로 에러 발생 시 전체 롤백됨
	                throw new RuntimeException("2차 결제 준비 중 오류가 발생했습니다: " + e.getMessage());
        	}
        }
        
        // 배송 이력 등록 
        DeliveryHistoryDTO history = new DeliveryHistoryDTO();
        history.setDeliveryId(deliveryDTO.getDeliveryId());
        if (oldData != null) {
            history.setPrevDeliveryStatus(oldData.getDeliveryStatus()); 
        }
        history.setDeliveryStatus(deliveryDTO.getDeliveryStatus());
        history.setRegId(deliveryDTO.getUpdId()); // 수정자를 등록자로 기록
        history.setMemo("배송 상태 및 정보 수정");
        
        deliveryMapper.insertDeliveryHistory(history);
        
        // 알림
        if(newStatus  != null && (oldData == null || oldData.getDeliveryStatus() != newStatus)) {
        	String receiverUserId =
        		    deliveryMapper.selectReceiverUserId(deliveryDTO.getDeliveryId());
        	
        	if(receiverUserId != null && !receiverUserId.isEmpty()) {
        		String msg = String.format("주문하신 상품이 [%s] 상태로 변경되었습니다.", newStatus.getDescription());
        		
        		notificationService.send(receiverUserId, "DELIVERY", deliveryDTO.getDeliveryId(), msg, deliveryDTO.getUpdId());
        	}
    	}
	}
	
	// 삭제 (비활성화)
	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean removeDelivery(int deliveryId, String updId) {
		
		return deliveryMapper.deleteDelivery(deliveryId, updId) > 0;
	}
}