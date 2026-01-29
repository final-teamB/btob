package io.github.teamb.btob.mapper.mgmtAdm;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PurchaseManagementMapper {

	// 조회
	void selectOrderMstByPurchseList(Integer startRow, 
								Integer limit, 
								String searchCondition);
	
	// 상세조회
	void selectOrderMstByPurchseToId(Integer orderId);
}
