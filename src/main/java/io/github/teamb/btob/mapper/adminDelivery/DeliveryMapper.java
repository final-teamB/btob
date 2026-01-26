package io.github.teamb.btob.mapper.adminDelivery;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;

@Mapper
public interface DeliveryMapper {
	
	// 전체 배송 목록 조회 (관리자용)
	List<DeliveryDTO> selectDeliveryList();
	
	// 목록에서 특정 배송 정보 수정 (운송장 번호, 상태 변경)
	int updateDelivery(DeliveryDTO deliveryDTO);
}
