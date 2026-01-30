package io.github.teamb.btob.mapper.mgmtAdm;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderManagementMapper {
	
	// 조회
	void selectOrderMstList(Integer startRow, 
					Integer limit, 
					String searchCondition);
	
	// 상세조회
	void selectOrderMstInfoById(Integer orderId);
}
