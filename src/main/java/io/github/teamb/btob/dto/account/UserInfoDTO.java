package io.github.teamb.btob.dto.account;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 사용자 정보 관련 DTO
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Data
public class UserInfoDTO {
	
	// TB_USERS
    private Integer userNo;			// 사용자 식별자
    private String userId;			// 사용자 아이디
    private String password;		// 사용자 패스워드
    private String userName;		// 사용자명
    private String phone;			// 사용자 연락처
    private String email;			// 사용자 이메일
    private String companyCd;		// 사용자 회사 코드
    
    private String userType;        // 사용자 권한 ADMIN, MASTER, USER
    private String appStatus;       // 사용자 승인 상태 PENDING (사용대기중) , APPROVED(승인), REJECTED(반려)
    private String accStatus;       // 사용자 계정 상태 ACTIVE (사용가능), INACTIVE(사용불가), LOCKED(계정잠금), SLEEP(휴먼계정), DELETED(폐지), BANNED(벤처리), EXPIRED(만료)
    
    private LocalDateTime regDtime;	// 등록일자
    private String regId;			// 등록아이디
    private LocalDateTime updDtime;	// 수정일자
    private String updId;			// 수정아이디
    private String useYn;			// 사용여부
    private String isRepresentative;// 대표자여부
    private String position;		// 직급
    

    private Integer userLoginFailCnt;		// 사용자 로그인 누적 실패 횟수
    private LocalDateTime userExpiredDate;	// 사용자 계정 만료 기한
    private LocalDateTime pwExpiredDate;	// 사용자 비밀번호 만료 기한
    
    private String newPassword;			// 변경할 비밀번호
    private String previousPassword;	// 이전 비밀번호
    
    //TB_COMPANIES
    private Integer companySeq;             // 식별자
    private String companyName;             // 회사명
    private String companyPhone;            // 회사 번호
    private String addrKor;                 // 한글 주소
    private String addrEng;                 // 영문 주소
    private String zipCode;                 // 우편 번호
    private String bizNumber;               // 사업자 번호
    private String customsNum;              // 통관 번호
    private String masterId;                // 대표자 ID
}
