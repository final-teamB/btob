package io.github.teamb.btob.dto.mgmtAdm.compy;

import lombok.Data;

import java.time.LocalDateTime;

/**
 *
 * 회사관리 검색 조회 DTO
 * @author GD
 * @since 2026. 2. 17.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 17.  GD       최초 생성
 */
@Data
public class SearchConditionCompyDTO {

        // TB_COMPANIES
        private Integer companySeq;             // 식별자
        private String companyCd;               // 회사코드
        private String companyName;             // 회사명
        private String companyPhone;            // 회사 번호
        private String masterId;                // 대표자 ID
        private String userName;                // 대표자명
        private String bizNumber;               // 사업자 번호
        private String customsNum;              // 통관 번호
        private LocalDateTime regDtime;         // 등록 일자
        private LocalDateTime updDtime;         // 수정 일자
        private String useYn;                   // 사용여부

        private Integer rownm;                  // 행 번호

        // 파일 이미지
        private String strFileNm;
        private String imgUrl;
}
