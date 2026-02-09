package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;


/**
 * 
 * 컨트롤러단에서 사용할 상품수정 Request DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class ProductModifyRequestDTO {
	
	// 상품 기본 정보
	private UpdateProductDTO productBase;
	
	// 상품 상세 정보
	private UpdateProductDetailInfoDTO productDetail;
}
