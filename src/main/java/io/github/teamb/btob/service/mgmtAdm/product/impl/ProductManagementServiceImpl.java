package io.github.teamb.btob.service.mgmtAdm.product.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.mapper.mgmtAdm.ProductMgmtAdmMapper;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class ProductManagementServiceImpl implements ProductManagementService{
	
	private final CommonService commonService;
	private final ProductMgmtAdmMapper productMgmtAdmMapper;

	/**
	 * 
	 * 상품 검색 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param searchParams
	 * @return PagingResponseDTO<>(productList, totalCnt)
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchConditionProductDTO> getSearchConditionProductList(
									Map<String, Object> searchParams) throws Exception {

		// 파라미터 검증
		if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
			
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 1. 전체 건수 조회 (검색 조건 유지)
	    // searchParams에서 검색 키워드만 뽑아서 전달
	    String searchCondition = (String) searchParams.get("searchCondition");
	    Integer totalCnt = productMgmtAdmMapper.selectProductSearchConditionListCntAdm(searchCondition);

	    // 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
	    List<SearchConditionProductDTO> productList = Collections.emptyList();
	    
	    if (totalCnt > 0) {
	    	
	        productList = productMgmtAdmMapper.selectProductSearchConditionListAdm(searchParams);
	    }

	    // 3. 통합 객체로 반환
	    return new PagingResponseDTO<>(productList, totalCnt);
	}

	
	/**
	 * 
	 * 상품 상세 정보 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param fuelId
	 * @return productDetailInfo
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public SearchDetailInfoProductDTO getProductDetailInfo(Integer fuelId) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(fuelId)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		SearchDetailInfoProductDTO productDetailInfo = productMgmtAdmMapper.selectProductDetailInfoByIdAdm(fuelId);
		
		if ( !(commonService.nullEmptyChkValidate(productDetailInfo)) ) {
		    throw new Exception("조회된 상품 상세 정보가 없습니다.");
		}
		
		return productDetailInfo;
	}

	/**
	 * 
	 * 상품 등록
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param RequestDTO
	 * @return result
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer registerProduct(ProductRegisterRequestDTO RequestDTO) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(RequestDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 상품 기본 정보 등록
	    Integer result = productMgmtAdmMapper.insertProductAdm(RequestDTO.getProductBase());
	    
	    if (result > 0) {

	    	RequestDTO.getProductDetail().setFuelId(RequestDTO.getProductBase().getFuelId());
	        
	        // 상품 상세 정보 등록
	        Integer detailResult = productMgmtAdmMapper.insertProductDetailInfoAdm(RequestDTO.getProductDetail());
	        
	        if (detailResult <= 0) {
	            throw new Exception("상품 상세 정보 등록에 실패했습니다.");
	        }
	    } else {
	        throw new Exception("상품 기본 정보 등록에 실패했습니다.");
	    }
	    
	    return result; 
	}

	/**
	 * 
	 * 상품 정보 수정
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param RequestDTO
	 * @return result
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer modifyProduct(ProductModifyRequestDTO RequestDTO) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(RequestDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 상품 기본 정보 수정
		Integer result = productMgmtAdmMapper.updateProductAdm(RequestDTO.getProductBase());
		
		if (result > 0) {
		       
		       // 상품 상세 정보 수정
		       Integer detailResult = productMgmtAdmMapper.updateProductDetailInfoAdm(RequestDTO.getProductDetail());
		       
		       if (detailResult <= 0) {
		           throw new Exception("상품 상세 정보 수정에 실패했습니다.");
		       }
		   } else {
		       throw new Exception("상품 기본 정보 수정에 실패했습니다.");
		   }
		   
		return result; 
	}

	/**
	 * 
	 * 상품 미사용 처리
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param RequestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer unUseProduct(ProductUnUseRequestDTO RequestDTO) throws Exception {

		if ( !(commonService.nullEmptyChkValidate(RequestDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 상품 기본 정보 미사용
		Integer result = productMgmtAdmMapper.deleteProductByIdAdm(RequestDTO);
		
		if (result > 0) {
		       
		       // 상품 세부 정보 미사용
		       Integer detailResult = productMgmtAdmMapper.deleteProductDetailInfoByIdAdm(RequestDTO);
		       
		       if (detailResult <= 0) {
		           throw new Exception("상품 상세 정보 미사용 수정에 실패했습니다.");
		       }
		   } else {
		       throw new Exception("상품 기본 정보 미사용 수정에 실패했습니다.");
		   }
		   
		return result;
	}

}
