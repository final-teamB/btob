package io.github.teamb.btob.dto.account;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class LoginValidateDTO {
	
	// 사용자
    private String userId;			// 사용자 아이디 검증
    private String password;		// 사용자 비밀번호
    private String accStatus;		// 사용자 계정 상태 ACTIVE (사용가능), INACTIVE(사용불가), LOCKED(계정잠금), SLEEP(휴먼계정), DELETED(폐지), BANNED(벤처리), EXPIRED(만료)
    private String accSttsNm;
    private String appStatus;		// PENDING (사용대기중) , APPROVED(승인), REJECTED(반려)
    private String appSttsNm;
    private Integer userLoginFailCnt;		// 로그인 실패 횟수
    private LocalDateTime userExpiredDate;	// 사용기간 만료여부
    private LocalDateTime pwExpiredDate;	// 비밀번호 만료 여부

    // 권한
    private String userType;		// 사용자 권한
}
