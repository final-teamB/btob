package io.github.teamb.btob.dto.mgmtAdm.product;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import lombok.Data;

/**
 * 
 * 엑셀 일괄 업로드 시 사용할 DTO
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Data
public class ProductUploadExcelDTO {

	// 기본테이블
	private Integer fuelId;			// 생성식별번호
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
    
    // 상세테이블
    private Integer apiGrv;          // API 비중
    private Integer sulfurPCnt;      // 유황 함량
    private Integer flashPnt;        // 인화점
    private Integer viscosity;       // 점도
    private Integer density15c;      // 15도 밀도
    private String fuelMemo;		// 상세내용
    
    // 이미지 일괄 업로드
    // 공통첨부파일 사용 TB_ATCH_FILE_MST
    // 메인이미지 ( PR_IMG_DETAIL )
    private String orgFileNm;		// 원본파일명
    private String filePath;		// 파일경로
    private String fileExt;			// 파일 확장자
    
    private String mainFileNm;  // '메인이미지명' 컬럼과 매핑
    private String subFileNm;   // '서브이미지명' 컬럼과 매핑
    
    
    /**
     * 상품 기본 정보 DTO로 변환
     */
    public InsertProductDTO toBaseDTO() {
        return InsertProductDTO.builder()
                .fuelCd(this.fuelCd)
                .fuelNm(this.fuelNm)
                .fuelCatCd(this.fuelCatCd)
                .originCntryCd(this.originCntryCd)
                .baseUnitPrc(this.baseUnitPrc)
                .currStockVol(this.currStockVol)
                .safeStockVol(this.safeStockVol)
                .volUnitCd(this.volUnitCd)
                .itemSttsCd(this.itemSttsCd)
                .useYn(this.useYn)
                .regId(this.regId)
                .build();
    }

    /**
     * 상품 상세 정보 DTO로 변환
     */
    public InsertDetailInfoProductDTO toDetailDTO() {
        return InsertDetailInfoProductDTO.builder()
                .apiGrv(this.apiGrv)
                .sulfurPCnt(this.sulfurPCnt)
                .flashPnt(this.flashPnt)
                .viscosity(this.viscosity)
                .density15c(this.density15c)
                .fuelMemo(this.fuelMemo)
                .regId(this.regId)     
                .useYn(this.useYn)
                .build();
    }
    
    /**
     * 첨부파일 정보 DTO로 변환
     */
    public AtchFileDto toAtchFileDTO(Integer refId, String systemId, String fileName) {
    	
        AtchFileDto dto = new AtchFileDto();
        dto.setRefId(refId);
        dto.setSystemId(systemId);
        dto.setOrgFileNm(fileName); // 엑셀에서 읽어온 파일명
        // 나머지 UUID 파일명, 경로, 사이즈 등은 실제 파일 처리 시점에 FileService에서 채워짐
        return dto;
    }
}
