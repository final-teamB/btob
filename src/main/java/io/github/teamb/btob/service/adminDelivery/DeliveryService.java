package io.github.teamb.btob.service.adminDelivery;

import java.util.List;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;

public interface DeliveryService {

	// 전체 배송 목록 
	List<DeliveryDTO> getDeliveryList();
	
	// 목록에서 배송 정보 수정 (운송장 번호, 배송 상태)
	boolean modifyDelivery(DeliveryDTO deliveryDTO);
}
