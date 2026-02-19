package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;

/**
 * 
 * 반려 절차 시 상품 수량 회수 DTO
 * @author GD
 * @since 2026. 2. 13.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 13.  GD       최초 생성
 */
@Data
public class UpdateProductCurrVolDTO {

	private Integer fuelId;		// 상품 식별자
	private Integer orderQty;	// 주문 및 회수 상품 수량
	private String orderStatus;	// 주문진행상태
	private String requestType; // UP, DOWN
}
