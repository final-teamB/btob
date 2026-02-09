package io.github.teamb.btob.mapper.order;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.est.EstDocListDTO;
import io.github.teamb.btob.dto.order.OrderDTO;


@Mapper
public interface OrderMapper {

	String selectFormattedOrderNo(String string, String loginUserId);

	void upsertOrderMaster(OrderDTO orderDto);

	Integer getOrderIdByOrderNo(String orderNo);

	String selectFormattedEstNo(String systemId, String loginUserId);

	void insertEstDoc(EstDocListDTO docDto);

}
