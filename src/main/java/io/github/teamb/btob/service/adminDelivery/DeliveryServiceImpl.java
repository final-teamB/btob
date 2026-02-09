package io.github.teamb.btob.service.adminDelivery;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Spring 트랜잭션 권장

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryHistoryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryStatus;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeliveryServiceImpl implements DeliveryService {
	
	private final DeliveryMapper deliveryMapper;
	private final NotificationService notificationService;

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
		
        // 배송 정보 업데이트 
        deliveryMapper.updateDelivery(deliveryDTO);

        // 주문 테이블 상태 동기화 
        if (deliveryDTO.getDeliveryStatus() != null) {
            deliveryMapper.updateOrderStatus(deliveryDTO);
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