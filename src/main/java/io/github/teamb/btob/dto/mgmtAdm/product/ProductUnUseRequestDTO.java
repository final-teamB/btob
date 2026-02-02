package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;

/**
 * 
 * 컨트롤러단에서 사용하는 상품 미사용 Request DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class ProductUnUseRequestDTO {
	
	private String useYn;		// 사용여부
	private String updId;		// 수정자
	private Integer fuelId;		// 식별자
}
