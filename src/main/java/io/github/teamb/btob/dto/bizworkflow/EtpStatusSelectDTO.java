package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

/**
 * 
 * ETP STATUS SELECT DTO
 * 견적 ~ 주문 상태코드 업데이트 시 요청 들어온 진행건의 현재 상태코드 확인 DTO
 * 연관 테이블 TB_EST_MST (견적), TB_ORDER_MST (주문), TB_PAYMENT_MST (결제)
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class EtpStatusSelectDTO {
	
	// 동적쿼리시 사용할 DTO
	private String targetTable;		// 업데이트 대상 테이블
	private String targetPkCol;			// 업데이트 테이블 조건절에 들어갈 PK컬럼명
	private String targetStatusCol;
	private Integer refId;			// 고유식별번호
	private Integer apprUserNo;		// 요청자
	private String userId;
}