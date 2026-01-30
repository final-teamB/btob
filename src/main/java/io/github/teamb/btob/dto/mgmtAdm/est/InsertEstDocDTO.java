package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;

/**
 * 
 * 견적서 등록 ( 3 )
 * 관련 테이블 == TB_EST_DOC
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class InsertEstDocDTO {
	
	private String estNo;          // 견적번호 (예: EST-2026-001)
    private String companyName;    // 회사명
    private String companyPhone;   // 회사연락처
    private Integer requestUserId; // 요청자ID
    private Integer apprUserId;    // 승인자ID
    private String ctrtNm;         // 계약명
    private Integer estCartId;		// 장바구니 식별자
    private String estdtMemo;      // 요청 상세 내용
    private Integer baseTotalAmount; // 기존 총액
    private Integer targetTotalAmount; // 희망 총액
}
