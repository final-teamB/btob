package io.github.teamb.btob.mapper.payment;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.payment.PaymentRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentViewDTO;

@Mapper
public interface PaymentMapper {
	
	PaymentViewDTO getPaymentViewInfo(String orderNo);

	void insertPaymentMst(PaymentRequestDTO payment);

	String selectFormattedPaymentNo(String systemId, String loginUserId);

}
