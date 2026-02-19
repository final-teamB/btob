package io.github.teamb.btob.dto.mgmtAdm.compy;

import lombok.Data;

import java.time.LocalDateTime;

/**
 *
 * 회사관리 상세 정보 수정 DTO
 * @author GD
 * @since 2026. 2. 17.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 17.  GD       최초 생성
 */
@Data
public class UpdateCompyDTO {

    private Integer companySeq;             // 식별자
    private String companyName;             // 회사명
    private String companyPhone;            // 회사 번호
    private String addrKor;                 // 한글 주소
    private String addrEng;                 // 영문 주소
    private String zipCode;                 // 우편 번호
    private String bizNumber;               // 사업자 번호
    private String customsNum;              // 통관 번호
    private String masterId;                // 대표자 ID
    private String userName;                // 대표자명
    private LocalDateTime updDtime;         // 수정 일자
    private String updId;                   // 수정자
    private String useYn;                   // 사용여부
}
