package io.github.teamb.btob.mapper.adminDelivery;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.dto.adminDelivery.DeliveryHistoryDTO;

@Mapper
public interface DeliveryMapper {
	
	// 전체 배송 목록 조회 (주문 정보 조인)
	List<DeliveryDTO> selectDeliveryList(DeliveryDTO deliveryDTO);
	
	// 배송 정보 상세보기
	DeliveryDTO selectDeliveryDetail(int deliveryId);
	
	// 배송 테이블 수정 (목록 수정 및 상세 수정 공통 사용)
    int updateDelivery(DeliveryDTO deliveryDTO);
    
    /*
       주문 상태 조회
       주문 상태가 pm002 -> dv001~5 / pm004 -> dv006~7
    */
    String getOrderStatusByOrderId(int order_id);
    
	
	// 주문 상태 동기화 (주문 테이블)
	int updateOrderStatus(DeliveryDTO deliveryDTO);
	
	// 삭제 (비활성화)
	int deleteDelivery(@Param("deliveryId") int deliveryId, @Param("updId") String updId);
	
	// 배송 이력 등록
	int insertDeliveryHistory(DeliveryHistoryDTO deliveryHistoryDTO);
	
	// 알림 수신자 user_id(email) 조회
	String selectReceiverUserId(int deliveryId); 
}
