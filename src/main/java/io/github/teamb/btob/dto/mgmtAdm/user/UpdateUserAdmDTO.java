package io.github.teamb.btob.dto.mgmtAdm.user;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 사용자 기본 정보 수정 DTO
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Data
public class UpdateUserAdmDTO {
	
	private Integer userNo;			// 생성식별번호
	private String userId;			// 사용자 아이디
	private String password;		// 사용자 비밀번호 ( 기존비밀번호 )
	private String userName;		// 사용자 성함
	private String phone;			// 사용자 연락처
	private String email;			// 사용자 이메일
	
	private String address;			// 회사주소
	private String detailAddress;	// 상세주소
	private String postcode;		// 회사 우편번호
	private String position;		// 직급
	
	private String userType;		// 사용자권한
	private String appStatus;		// 가입승인상태
	private String accStatus;		// 계정상태
	
	private LocalDateTime updDtime; // 수정일자
	private String updId;		// 수정자
	private String useYn;		// 사용여부

	// 비밀번호 변경시 사용
    private String newPassword;         // 새 비밀번호  
    private String confirmPassword;     // 새 비밀번호 확인
}
