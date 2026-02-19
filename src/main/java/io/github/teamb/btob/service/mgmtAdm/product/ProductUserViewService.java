package io.github.teamb.btob.service.mgmtAdm.product;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;

public interface ProductUserViewService {
	
		// 상품 검색 조회 목록
		PagingResponseDTO<SearchConditionProductDTO> getSearchConditionUsrProductList(
											Map<String, Object> searchParams) throws Exception;
		
		// 상품 상세 정보
		SearchDetailInfoProductDTO getUsrProductDetailInfo (Integer fuelId) throws Exception;
		
		// 사이드바 추출
		Map<String, List<SelectBoxVO>> getProductUsrSideBarList();
}
