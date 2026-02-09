package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;

/**
 * 
 * 견적서 등록 ( 2 )
 * 견적서 장바구니 상세 물품 등록
 * 관련 테이블 == TB_EST_CART_ITEM
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class InsertEstCartItemDTO {
	
	// 견적서 장바구니 상세 물품
    private Integer estCartId;		// 장바구니 식별자
    private Integer productId;       // 상품 고유번호
    private String productNm;        // 상품명 (조인 또는 함수용)
    private Integer productQty;      // 물품수량
    private Integer baseProductPrc;  // 기존단가
    private Integer baseProductAmt;  // 기존단가 * 물품수량
    private Integer targetProductPrc;// 희망단가
    private Integer targetProductAmt;// 희망단가 * 물품수량
    private String regId;			// 등록자
}
