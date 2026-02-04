package io.github.teamb.btob.dto.mgmtAdm.est;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 견적서 관리 조회 DTO
 * 관련 테이블 = TB_EST_MST, TB_EST_DOC
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class SearchConditionEstDTO {
	
	private Integer estId;			// 식별자
	private Integer estNo;			// 견적서번호
	private String ctrtNm;			// 계약명
	private String companyName; 	// 회사명
	private String companyPhone;	// 회사연락처
	private Integer requestUserId;	// 요청자ID
	private String requestUserNm;	// 요청자 이름 (fnc_get_usernm 활용용)
	private LocalDateTime regDtime;	// 생성일자
	private LocalDateTime expireDtime;	// 견적서 만료일자
	private String etpSttsCd;	// 견적서 상태코드
	private LocalDateTime apprDtime;	// 승인,반려 일자
	
	// 순번
	private Integer rownm;
}
