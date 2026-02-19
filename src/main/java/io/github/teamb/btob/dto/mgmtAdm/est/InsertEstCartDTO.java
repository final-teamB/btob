package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;

/**
 * 
 * 견적서 등록 ( 1 )
 * 견적 장바구니 메인 생성
 * 관련 테이블 == TB_EST_CART
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class InsertEstCartDTO {
	
	private String regId; // 요청자값을 할당 requestUserId
	private String requestUserId;
	
	// 카트 식별자
	private Integer estCartId;
}
