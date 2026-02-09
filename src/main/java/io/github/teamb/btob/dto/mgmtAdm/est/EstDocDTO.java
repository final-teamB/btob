package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;


/**
 * 
 * 견적서 상세 정보
 * 관련 테이블 = TB_EST_MST, TB_EST_DOC, TB_EST_CART_ITEM
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class EstDocDTO {
	
	// 견적서
	private Integer estId;		   // 견적서 관리 고유식별자
	private Integer estDocId;	   // 견적서 문서 식별자
    private String estNo;          // 견적번호 (예: EST-2026-001)
    private String companyName;    // 회사명
    private String companyPhone;   // 회사연락처
    private Integer requestUserId; // 요청자ID
    private String requestUserNm;  // 요청자 이름 (fnc_get_usernm 활용용)
    private Integer apprUserId;    // 승인자ID
    private String apprUserNm;     // 승인자 이름 (fnc_get_usernm 활용용)
    private String ctrtNm;         // 계약명
    private String estdtMemo;      // 요청 상세 내용
    // 자바단에서 계산
    private Integer baseTotalAmount; // 기존 총액
    private Integer targetTotalAmount; // 희망 총액
    
    // 견적서 장바구니 상세 물품
    private Integer estCartId;		// 장바구니 식별자
    private Integer productId;       // 상품 고유번호
    private String productNm;        // 상품명 (조인 또는 함수용)
    private Integer productQty;      // 물품수량
    private Integer baseProductPrc;  // 기존단가
    private Integer baseProductAmt;  // 기존단가 * 물품수량
    private Integer targetProductPrc;// 희망단가
    private Integer targetProductAmt;// 희망단가 * 물품수량
    
    // 사용자 공통
    private Integer regId;	// 생성한 사용자
}
