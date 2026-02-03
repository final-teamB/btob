package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.product.InsertDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductDetailInfoDTO;
import io.github.teamb.btob.dto.mgmtAdm.user.SearchConditionUserDTO;
import io.github.teamb.btob.dto.mgmtAdm.user.SearchDetailInfoUserDTO;

@Mapper
public interface UserMgmtAdmMapper {
	
		// 사용자 검색 조회
		List<SearchConditionUserDTO> selectUserSearchConditionListAdm(Map<String, Object> searchParams);
		
		// 사용자 검색 조회 건수
		Integer selectUserSearchConditionListCntAdm(String searchCondition);
		
		// 사용자 상세조회
		SearchDetailInfoUserDTO selectUserDetailInfoByIdAdm(Integer userNo);
		
		// 사용자 등록?
		//Integer insertProductAdm(InsertProductDTO insertProductDTO);
		
		// 사용자 상세정보 등록? 이건 회원가입에서 따오기
		//Integer insertProductDetailInfoAdm(InsertDetailInfoProductDTO insertDetailInfoProductDTO);
		
		// 상품 수정
		Integer updateProductAdm(UpdateProductDTO updateProductDTO);
		
		// 상품 상세정보 수정
		Integer updateProductDetailInfoAdm(UpdateProductDetailInfoDTO updateProductDetailInfoDTO);
		
		// 상품 삭제 ( 비활성화 )
		Integer deleteProductByIdAdm(ProductUnUseRequestDTO productUnUseRequestDTO);
		
		// 상품 상세정보 삭제 ( 비활성화 )
		Integer deleteProductDetailInfoByIdAdm(ProductUnUseRequestDTO productUnUseRequestDTO);
}
