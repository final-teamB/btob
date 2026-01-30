package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMgmtAdmMapper {
	
	// 주문/구매 관리 조회
	void selectOrderSearchConditionListAdm(Map<String, Object> params);
	
	// 주문/구매 관리 조회 건수
	void selectOrderSearchConditionListCntAdm(Map<String, Object> params);
	
	// 주문/구매 관리 상세조회
	void selectOrderDetailInfoByIdAdm(Integer orderId);
}
