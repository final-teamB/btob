package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductDetailInfoDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;

@Mapper
public interface ProductMgmtAdmMapper {
	
	// 상품 검색 조회
	// Integer startRow, Integer limit, String searchCondition
	List<SearchConditionProductDTO> selectProductSearchConditionListAdm(Map<String, Object> searchParams);
	
	// 상품 조회 건수
	Integer selectProductSearchConditionListCntAdm(String searchCondition);
	
	// 상품 상세조회
	SearchDetailInfoProductDTO selectProductDetailInfoByIdAdm(Integer fuelId);
	
	// 상품 등록
	Integer insertProductAdm(InsertProductDTO insertProductDTO);
	
	// 상품 상세정보 등록
	Integer insertProductDetailInfoAdm(InsertDetailInfoProductDTO insertDetailInfoProductDTO);
	
	// 상품 수정
	Integer updateProductAdm(UpdateProductDTO updateProductDTO);
	
	// 상품 상세정보 수정
	Integer updateProductDetailInfoAdm(UpdateProductDetailInfoDTO updateProductDetailInfoDTO);
	
	// 상품 삭제 ( 비활성화 )
	Integer deleteProductByIdAdm(ProductUnUseRequestDTO productUnUseRequestDTO);
	
	// 상품 상세정보 삭제 ( 비활성화 )
	Integer deleteProductDetailInfoByIdAdm(ProductUnUseRequestDTO productUnUseRequestDTO);
}
