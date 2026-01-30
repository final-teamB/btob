package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Data;

/**
 * 
 * 상품 등록 DTO
 * 관련 테이블 == TB_OIL_MST
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class InsertProductDTO {
	
    private String fuelCd;          // 유류 코드
    private String fuelNm;          // 유류 명칭
    private String fuelCatCd;       // 유류 종류 코드
    private String originCntryCd;   // 원산지 국가 코드
    private Integer baseUnitPrc;    // 기준 단가
    private Integer currStockVol;   // 현재 재고량
    private Integer safeStockVol;   // 안전 재고량
    private String volUnitCd;       // 용량 단위 코드
    private String itemSttsCd;      // 재고 상태 코드
    private String regId;           // 등록자 ID
    private String useYn;			// 사용여부 YN
}
