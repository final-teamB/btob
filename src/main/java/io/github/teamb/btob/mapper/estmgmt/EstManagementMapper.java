package io.github.teamb.btob.mapper.estmgmt;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.estmgmt.EstSttsDTO;

@Mapper
public interface EstManagementMapper {
	
	// 견적서 조회
	void selectRfqList(Integer startRow, 
						Integer limit, 
						String searchCondition);
	
	// 견적서 조회 건수
	void countRfqListCnt(String searchCondition);
	
	// 견적서 상세 조회
	void selectRfqInfoById(Integer rfqId);
}
