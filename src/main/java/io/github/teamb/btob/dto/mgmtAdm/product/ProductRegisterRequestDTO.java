package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;

/**
 * 
 * 컨트롤러단에서 사용할 상품등록 Request DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class ProductRegisterRequestDTO {
	
	// 1. 상품 기본 정보 (TB_PRODUCT 관련)
    private InsertProductDTO productBase;
    
    // 2. 상품 상세 정보 (TB_PRODUCT_DETAIL 관련)
    private InsertDetailInfoProductDTO productDetail;
}
