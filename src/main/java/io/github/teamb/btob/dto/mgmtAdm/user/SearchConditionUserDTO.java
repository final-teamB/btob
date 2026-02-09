package io.github.teamb.btob.dto.mgmtAdm.user;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 사용자관리 검색 조회 DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class SearchConditionUserDTO {
	
	private Integer userNo;			// 생성식별번호
	private String userId;			// 사용자 아이디
	private String userName;		// 사용자 성함
	private String companyName;		// 회사명
	private String userType;		// 사용자권한
	private String appStatus;		// 가입승인상태
	private String accStatus;		// 계정상태
	private LocalDateTime regDtime;	// 등록일자
	private LocalDateTime updDtime; // 수정일자
	
	// 순번
	private Integer rownm;
}

/*
private Integer userNo;
private String userId;
private String password;
private String userName;
private String phone;
private String email;
private String companyCd;
private String userType;        // ADMIN, MASTER, USER
private String appStatus;       // PENDING, APPROVED, REJECTED
private String accStatus;       // ACTIVE, SLEEP, STOP
private java.time.LocalDateTime regDtime;
private String regId;
private java.time.LocalDateTime updDtime;
private String updId;
private String useYn;
private String address;
private String businessNumber;
private String isRepresentative;
private String position;
private String detailAddress;
private String postcode;

-------------------

	private Integer companySeq;
    private String companyCd;
    private String companyName;
    private String bizNumber;
    private String masterName;
    private java.time.LocalDateTime regDtime;
    private String regId;
    private java.time.LocalDateTime updDtime;
    private String updId;
    private String useYn;


*/