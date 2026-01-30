package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PaymentMgmtAdmMapper {

	// 결제 관리 검색 조회
	void selectPaymentSearchConditionListAdm(Map<String, Object> params);
	
	// 결제 관리 검색 조회 건수
	void selectPaymentSearchConditionListCntAdm(Map<String, Object> params);
	
	// 결제 관리 상세 조회
	void selectPaymentDetailInfoByIdAdm(Integer orderId);
}
