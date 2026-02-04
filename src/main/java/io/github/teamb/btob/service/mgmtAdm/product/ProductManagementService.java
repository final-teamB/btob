package io.github.teamb.btob.service.mgmtAdm.product;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;

public interface ProductManagementService {
	
	// 상품 검색 조회 목록
	PagingResponseDTO<SearchConditionProductDTO> getSearchConditionProductList(
										Map<String, Object> searchParams) throws Exception;
	
	// 상품 상세 정보
	SearchDetailInfoProductDTO getProductDetailInfo (Integer fuelId) throws Exception;
	
	// 상품 등록
	Integer registerProduct(ProductRegisterRequestDTO RequestDTO
								,List<MultipartFile> mainFiles 
						        ,List<MultipartFile> subFiles 
						        ,List<MultipartFile> detailFiles) throws Exception;
	
	// 상품 수정
	Integer modifyProduct(ProductModifyRequestDTO requestDTO
							,List<String> mainRemainNames  
				            ,List<MultipartFile> mainFiles 
				            ,List<String> subRemainNames
				            ,List<MultipartFile> subFiles
				            ,List<String> DetailRemainNames
				            ,List<MultipartFile> detailFiles) throws Exception;
	
	// 상품 삭제
	Integer unUseProduct(ProductUnUseRequestDTO requestDTO) throws Exception;
}
