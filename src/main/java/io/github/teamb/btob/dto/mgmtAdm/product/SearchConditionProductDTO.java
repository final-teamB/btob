package io.github.teamb.btob.dto.mgmtAdm.product;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 상품관리 검색 조회 DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class SearchConditionProductDTO {
	
	// TB_OIL_MST (마스터 정보)
    private int fuelId;             // 유류 ID (PK, AI)
    private String fuelCd;          // 유류 코드
    private String fuelNm;          // 유류 명칭
    private String fuelCatNm;       // 유류 종류 명칭 (COMMON_TBL 조인 결과용)
    private String originCntryNm;   // 원산지 국가 명칭 (COMMON_TBL 조인 결과용)
    private Integer baseUnitPrc;    // 기준 단가
    private Integer currStockVol;   // 현재 재고량
    private Integer safeStockVol;   // 안전 재고량
    private String volUnitNm;       // 용량 단위 명칭 (COMMON_TBL 조인 결과용)
    private String itemSttsNm;      // 재고 상태 명칭 (COMMON_TBL 조인 결과용)
    private LocalDateTime regDtime; // 등록 일시
    private LocalDateTime updDtime; // 수정 일시
    private String useYn;           // 사용 여부 ( 표출, 미표출 )
    
    // 페이징 및 검색용 추가 필드
    private int rownm;              // 행 번호
    
    // 파일 이미지
    private String strFileNm;
    private String imgUrl;
}
