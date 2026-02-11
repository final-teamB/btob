package io.github.teamb.btob.dto.mgmtAdm.product;

import java.time.LocalDateTime;
import java.util.List;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import lombok.Data;

/**
 * 
 * 상품관리 - 상품 상세정보 DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class SearchDetailInfoProductDTO {
	
	// TB_OIL_MST (마스터 정보)
    private Integer fuelId;         // 유류 ID (PK, AI)
    private String fuelCd;          // 유류 코드
    private String fuelNm;          // 유류 명칭
    private String fuelCatCd;       // 유류 종류 코드
    private String fuelCatNm;       // 유류 종류 명칭 (COMMON_TBL 조인 결과용)
    private String originCntryCd;   // 원산지 국가 코드
    private String originCntryNm;   // 원산지 국가 명칭 (COMMON_TBL 조인 결과용)
    private Integer baseUnitPrc;    // 기준 단가
    private Integer currStockVol;   // 현재 재고량
    private Integer safeStockVol;   // 안전 재고량
    private String volUnitCd;       // 용량 단위 코드
    private String volUnitNm;       // 용량 단위 명칭 (COMMON_TBL 조인 결과용)
    private String itemSttsCd;      // 재고 상태 코드
    private String itemSttsNm;      // 재고 상태 명칭 (COMMON_TBL 조인 결과용)
    private String useYn;           // 사용 여부
    private LocalDateTime regDtime; // 등록 일시
    private String regId;           // 등록자 ID
    private LocalDateTime updDtime; // 수정 일시
    private String updId;           // 수정자 ID

    private String regNm;
    private String updNm;
    
    // TB_OIL_MST_DETAIL (상세 정보 조인용 필드)
    private Integer apiGrv;          // API 비중
    private Integer sulfurPCnt;      // 유황 함량
    private Integer flashPnt;        // 인화점
    private Integer viscosity;       // 점도
    private Integer density15c;      // 15도 밀도
    private String fuelMemo;
    
    // 파일 이미지
    private List<AtchFileDto> fileList;
    
    private String systemId;
    private Integer fileId;
    private String strFileNm;
    
}
