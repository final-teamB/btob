package io.github.teamb.btob.service.mgmtAdm.product;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductCurrVolDTO;

public interface ProductManagementService {
	
	// 상품 검색 조회 목록
	PagingResponseDTO<SearchConditionProductDTO> getSearchConditionProductList(
										Map<String, Object> searchParams) throws Exception;
	
	// 상품 상세 정보
	SearchDetailInfoProductDTO getProductDetailInfo (Integer fuelId) throws Exception;
	
	// 상품 등록
	Integer registerProduct(ProductRegisterRequestDTO requestDTO) throws Exception;
	
	// 상품 수정
	Integer modifyProduct(ProductModifyRequestDTO requestDTO
							,List<String> mainRemainNames  
				            ,List<MultipartFile> mainFiles 
				            ,List<String> subRemainNames
				            ,List<MultipartFile> subFiles) throws Exception;
	
	// 상품 삭제
	Integer unUseProduct(ProductUnUseRequestDTO requestDTO) throws Exception;
	
	// 셀렉박스 == 유류종류, 원산지 국가, 단위, 재고상태
	Map<String, List<SelectBoxVO>> registerProductSelectBoxList();
	
	// 주문 로직 시 제품 수량 변경
	void modifyProductCurrVol(UpdateProductCurrVolDTO updateProductCurrVolDTO) throws Exception;
}
