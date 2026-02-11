package io.github.teamb.btob.service.adminDelivery;

import java.util.List;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryHistoryDTO;

public interface DeliveryService {

	// 전체 배송 목록 
	List<DeliveryDTO> getDeliveryList(DeliveryDTO deliveryDTO);

	// 배송 정보 상세보기
	DeliveryDTO getDeliveryDetail(int deliveryId);
	
	// 통합 수정 (수정, 주문 상태 동기화, 배송이력 등록)
	void modifyDelivery(DeliveryDTO deliveryDTO);

	// 삭제 (비활성화)
	boolean removeDelivery(int deliveryId, String updId);
}
