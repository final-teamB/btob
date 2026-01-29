package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.ProductMgmtAdmDTO;

@Mapper
public interface ProductMgmtAdmMapper {
	
	// 상품 조회
	// Integer startRow, Integer limit, String searchCondition
	List<ProductMgmtAdmDTO> selectOilMstListAdm(Map<String, Object> searchParams);
	
	// 상품 조회 건수
	Integer countOilMstListCntAdm(String searchCondition);
	
	// 상품 상세조회
	ProductMgmtAdmDTO selectOilMstInfoByIdAdm(Integer fuelId);
	
	// 상품 등록
	int insertOilMstProductAdm(ProductMgmtAdmDTO productManagementDTO);
	int insertOilMstDetailProductAdm(ProductMgmtAdmDTO productManagementDTO);
	
	// 상품 수정
	int updateOilMstProductAdm(ProductMgmtAdmDTO productManagementDTO);
	int updateOilMstDetailProductAdm(ProductMgmtAdmDTO productManagementDTO);
	
	// 상품 삭제 ( 비활성화 )
	int deleteOilMstProductByIdAdm(Integer fuelId);
	int deleteOilMstDetailProductByIdAdm(Integer fuelId);
}
