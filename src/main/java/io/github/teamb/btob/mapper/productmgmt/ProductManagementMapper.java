package io.github.teamb.btob.mapper.productmgmt;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.productmgmt.ProductManagementDTO;

@Mapper
public interface ProductManagementMapper {
	
	// 조회
	void selectOilMstList(Integer startRow, 
					Integer limit, 
					String searchCondition);
	// 조회 건수
	void countOilMstListCnt(String searchCondition);
	
	// 상세조회
	void selectOilMstInfoById(Integer fuelId);
	
	// 등록
	void insertOilMstProduct(ProductManagementDTO productManagementDTO);
	
	// 수정
	void updateOilMstProduct(ProductManagementDTO productManagementDTO);
	
	// 삭제
	void deleteOilMstProductById(Integer fuelId);
}
