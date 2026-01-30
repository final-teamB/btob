package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;

/**
 * 
 * 상품관리에서 사용할 셀렉박스 조건 담는 DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class SelectBoxProductDTO {

	private String country;
	private String fuelCat;
	private String volUnit;
	private String oilItemStts;
}
