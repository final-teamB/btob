package io.github.teamb.btob.mapper.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.est.EstDocInsertDTO;
import io.github.teamb.btob.dto.order.OrderDTO;
import io.github.teamb.btob.dto.order.OrderHistoryDTO;
import io.github.teamb.btob.dto.order.OrderVoDTO;


@Mapper
public interface OrderMapper {

	//주문/배송목록
	List<OrderHistoryDTO> selectUserOrderList(OrderHistoryDTO dto, String userType);
	
	String selectFormattedOrderNo(@Param("prefix") String prefix, @Param("userId") String userId);
	String selectFormattedEstNo(String systemId, String userId);

	void upsertOrderMaster(OrderDTO orderDto);

	Integer getOrderIdByOrderNo(String orderNo);


	void insertEstDoc(EstDocInsertDTO docDto);

	OrderVoDTO getOrderDetailWithAll(int orderId);

	OrderVoDTO getOrderBasicInfoForPayment(int orderId);

	OrderVoDTO getOrderDetailWithAll(String orderNo);

	

}
