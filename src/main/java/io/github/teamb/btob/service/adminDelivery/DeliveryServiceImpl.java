package io.github.teamb.btob.service.adminDelivery;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Spring 트랜잭션 권장

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryHistoryDTO;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeliveryServiceImpl implements DeliveryService {
	
	private final DeliveryMapper deliveryMapper;

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
        // 1. 배송 정보 업데이트 
        deliveryMapper.updateDelivery(deliveryDTO);

        // 2. 주문 테이블 상태 동기화 
        if (deliveryDTO.getDeliveryStatus() != null) {
            deliveryMapper.updateOrderStatus(deliveryDTO);
        }

        // 3. 배송 이력 등록 
        DeliveryHistoryDTO history = new DeliveryHistoryDTO();
        history.setDeliveryId(deliveryDTO.getDeliveryId());
        history.setDeliveryStatus(deliveryDTO.getDeliveryStatus());
        history.setRegId(deliveryDTO.getUpdId()); // 수정자를 등록자로 기록
        history.setMemo("배송 상태 및 정보 수정");
        
        deliveryMapper.insertDeliveryHistory(history);
    }

	// 삭제 (비활성화)
	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean removeDelivery(int deliveryId, String updId) {
		
		return deliveryMapper.deleteDelivery(deliveryId, updId) > 0;
	}
}