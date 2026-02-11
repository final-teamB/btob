package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;

@Mapper
public interface ProductUserViewMapper {
	
		// 상품 검색 조회
		// Integer startRow, Integer limit, String searchCondition
		List<SearchConditionProductDTO> selectProductSearchConditionListUsr(Map<String, Object> searchParams);
		
		// 상품 조회 건수
		Integer selectProductSearchConditionListCntUsr(Map<String, Object> params);
		
		// 상품 상세조회
		SearchDetailInfoProductDTO selectProductDetailInfoByIdUsr(Integer fuelId);
}
