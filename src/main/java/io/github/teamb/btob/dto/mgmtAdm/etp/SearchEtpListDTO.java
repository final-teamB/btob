package io.github.teamb.btob.dto.mgmtAdm.etp;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 견적/주문/구매/결제 검색 조회 DTO
 * @author GD
 * @since 2026. 2. 12.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 12.  GD       최초 생성
 */
@Data
public class SearchEtpListDTO {
	
	private Integer rowNm; 		// 순번
	private String systemId;	// 시스템ID
	private Integer orderId;	// 주문식별자
	private String orderNo;		// 주문번호
	private Integer quoteReqId;	// 견적식별자
	private String estNo;		// 견적번호 
	private String ctrtNm;		// 견적서 계약명
	private Integer paymentId;	// 결제식별자
	private String paymentNo;	// 결제번호
	private String orderStatus;	// 진행상태코드
	private String etpSttsNm;	// 진행상태명
	private Integer userNo;		// 사용자식별자
	private String userId;		// 사용자아이디
	private String companyName;	// 회사이름
	private String userType;	// 사용자타입(직급)
	private String userName;	// 사용자명
	private LocalDateTime regDtime;	// 최초등록일자
	private String regId;		// 최초등록자
	private String useYn;		// 사용여부
	private LocalDateTime orderDate;	// 주문일자
	
	private String approveBtn;		// 승인버튼
	private String rejectBtn;		// 반려버튼
	
	private Integer ordYear;		// 연도 셀렉박스
	
	private String etpSttsCd;		// 진행상태코드
}
