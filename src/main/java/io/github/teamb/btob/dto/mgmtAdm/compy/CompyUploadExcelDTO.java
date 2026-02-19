package io.github.teamb.btob.dto.mgmtAdm.compy;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import lombok.Data;

import java.time.LocalDateTime;

/**
 *
 * 회사 정보 엑셀 일괄 업로드 시 사용할 DTO
 * @author GD
 * @since 2026. 2. 17.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 17.  GD       최초 생성
 */
@Data
public class CompyUploadExcelDTO {

    private Integer companySeq;             // 식별자
    private String companyCd;               // 회사코드
    private String companyName;             // 회사명
    private String companyPhone;            // 회사 번호
    private String addrKor;                 // 한글 주소
    private String addrEng;                 // 영문 주소
    private String zipCode;                 // 우편 번호
    private String bizNumber;               // 사업자 번호
    private String customsNum;              // 통관 번호
    private String masterId;                // 대표자 ID
    private String userName;                // 대표자명
    private LocalDateTime regDtime;         // 등록 일자
    private String regId;                   // 등록자
    private String useYn;                   // 사용여부

    // 이미지 일괄 업로드
    // 공통첨부파일 사용 TB_ATCH_FILE_MST
    private String orgFileNm;		// 원본파일명
    private String filePath;		// 파일경로
    private String fileExt;			// 파일 확장자

    private String companyLogoFileNm;  // '메인이미지명' 컬럼과 매핑

    /**
     *  DTO 변환
     */
    public InsertCompyDTO toBaseDTO() {
        return InsertCompyDTO.builder()
                .companySeq(this.companySeq)     // 식별자
                .companyCd(this.companyCd)       // 회사코드
                .companyName(this.companyName)   // 회사명
                .companyPhone(this.companyPhone) // 회사 번호
                .addrKor(this.addrKor)           // 한글 주소
                .addrEng(this.addrEng)           // 영문 주소
                .zipCode(this.zipCode)           // 우편 번호
                .bizNumber(this.bizNumber)       // 사업자 번호
                .customsNum(this.customsNum)     // 통관 번호
                .masterId(this.masterId)         // 대표자 ID
                .userName(this.userName)         // 대표자명
                .regDtime(this.regDtime)         // 등록 일자
                .regId(this.regId)               // 등록자
                .useYn(this.useYn)               // 사용 여부
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
