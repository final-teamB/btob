package io.github.teamb.btob.service.adminDelivery;

import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Spring 트랜잭션 권장

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
   
   private final List<String> CARRIERS = List.of("CJ대한통운", "한진택배", "롯데택배", "경동택배", "로젠택배");

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
    public DeliveryDTO modifyDelivery(DeliveryDTO deliveryDTO) {
		
		// 이전 데이터 조회
		DeliveryDTO oldData = deliveryMapper.selectDeliveryDetail(deliveryDTO.getDeliveryId());
	    if (oldData == null) {
	        throw new IllegalArgumentException("존재하지 않는 배송 정보입니다.");
	    }
        
        String orderStatus = oldData.getOrderStatus();
        
        // 2차결제완료(pm004) 시 자동 설정 로직
        if ("pm004".equals(orderStatus)
                && deliveryDTO.getDeliveryStatus() == DeliveryStatus.dv006
                && oldData.getDeliveryStatus() != DeliveryStatus.dv006) {
            
            // 운송장번호 자동 생성 
            if (deliveryDTO.getTrackingNo() == null || deliveryDTO.getTrackingNo().trim().isEmpty()) {
                Random random = new Random();
                long randomNo = 1000000000L + (long)(random.nextDouble() * 9000000000L);
                
                deliveryDTO.setTrackingNo("TRK" + randomNo);
            }
            
            // 택배사 자동 지정 
            if (deliveryDTO.getCarrierName() == null || deliveryDTO.getCarrierName().trim().isEmpty()) {
                int randomIndex = (int)(Math.random() * CARRIERS.size());
                
                deliveryDTO.setCarrierName(CARRIERS.get(randomIndex));
            }
        }

        // 주문상태에 따른 배송상태 변경 권한 체크
        if (deliveryDTO.getDeliveryStatus() != null && orderStatus != null) {
            String statusCode = deliveryDTO.getDeliveryStatus().name();
            
            Map<String, List<String>> rule = Map.of(
                "pm002", List.of("dv001", "dv002", "dv003", "dv004", "dv005"),
                "pm004", List.of("dv006", "dv007")
            );

            List<String> allowed = rule.get(orderStatus);
            if (allowed != null && !allowed.contains(statusCode)) {
                throw new IllegalArgumentException("[" + orderStatus + "] 단계에서 [" + statusCode + "] 상태로 변경할 수 없습니다.");
            }
        }
      
        // 배송 정보 업데이트 
        deliveryMapper.updateDelivery(deliveryDTO);
        
        // ⭐️ 3. [추가 로직] 배송 상태가 dv005(통관완료)로 변경되었을 때 2차 결제 요청 실행
        if (deliveryDTO.getDeliveryStatus() == DeliveryStatus.dv005 
            && (oldData.getDeliveryStatus() != DeliveryStatus.dv005)) {
            
            try {
                // PaymentService의 prepareSecondPayment 호출
                // oldData에서 orderId를, deliveryDTO에서 관리자 ID(updId)를 가져와 넘깁니다.
                paymentService.prepareSecondPayment(oldData.getOrderId(), deliveryDTO.getUpdId());     
            } catch (Exception e) {
                // 트랜잭션 롤백을 위해 RuntimeException으로 던짐
                throw new RuntimeException("2차 결제 요청 처리 중 오류가 발생했습니다.", e);
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
        DeliveryStatus newStatus = deliveryDTO.getDeliveryStatus();
        if(newStatus  != null && (oldData == null || oldData.getDeliveryStatus() != newStatus)) {

           String receiverUserId =
                  deliveryMapper.selectReceiverUserId(deliveryDTO.getDeliveryId());
           System.out.println("### 알림 대상자(주문자): " + receiverUserId);
           
           if(receiverUserId != null && !receiverUserId.isEmpty()) {
               String msg;
               
               // ⭐️ [추가] 통관완료(dv005)일 때만 특별 메시지 적용
               if (newStatus == DeliveryStatus.dv005) {
                   msg = String.format("주문하신 상품의 통관이 완료되었습니다. [2차 결제]를 진행해 주세요.", newStatus.getDescription());
               } else {
                   msg = String.format("주문하신 상품이 [%s] 상태로 변경되었습니다.", newStatus.getDescription());
               }
               
               // 기존 notificationService 호출 (여기서 한 번에 처리)
               notificationService.send(receiverUserId, "DELIVERY", deliveryDTO.getDeliveryId(), msg, deliveryDTO.getUpdId());
           }
       }
        
        return deliveryMapper.selectDeliveryDetail(deliveryDTO.getDeliveryId());
   }

	
	// 삭제 (비활성화)
	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean removeDelivery(int deliveryId, String updId) {
		
		return deliveryMapper.deleteDelivery(deliveryId, updId) > 0;
	}

}