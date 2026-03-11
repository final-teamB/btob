package io.github.teamb.btob.dto.account;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 
 * 회원 가입 시 회사 정보 DTO
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyInfoDTO {
	
	// TB_COMPANIES
    private Integer companySeq;             // 식별자
    private String companyCd;				// 회사코드
    private String companyName;             // 회사명
    private String companyPhone;            // 회사 번호
    private String addrKor;                 // 한글 주소
    private String addrEng;                 // 영문 주소
    private String zipCode;                 // 우편 번호
    private String bizNumber;               // 사업자 번호
    private String customsNum;              // 통관 번호
    private String masterId;                // 대표자 ID
    private LocalDateTime regDtime;			// 등록일자
    private String regId;					// 등록자
    private LocalDateTime updDtime;			// 수정일자
    private String updId;					// 수정자
}
