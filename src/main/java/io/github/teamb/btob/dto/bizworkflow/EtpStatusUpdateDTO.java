package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

/**
 * // 견적 요청중, 요청승인, 요청반려,  
		// 주문 요청중, 주문 요청승인, 주문 요청반려, 
		// 구매 요청중, 구매 요청승인, 구매 요청반려,
		// 결재 요청중, 결재 완료 (결제 1차, 2차)
		// 견적 ESTIMATE // ET001 요청중 // ET002 요청승인 // ET999 요청반려
		// 주문 ORDER 구매 PURCHASE 결재 PAYMENT
		// 요청중인경우에만 승인이나 반려처리가 가능하다
 * 
 * 
 * 
 * ETP STATUS UPDATE DTO
 * 견적/주문/구매/결제 상태코드 업데이트 DTO
 * 업데이트 테이블 == TB_EST_MST (견적), TB_ORDER_MST (주문), TB_PAYMENT_MST (결제) 
 * @author GD
 * @since 2026. 1. 27.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 27.  GD       최초 생성
 */

@Data
public class EtpStatusUpdateDTO {

    private Integer updId;           	// 수정자
	private String targetTable;			// 업데이트 테이블
	private String targetStatusCol;		// 업데이트 테이블 상태코드 컬럼
	private String targetPkCol;			// 업데이트 테이블 식별자 컬럼
	private String currentEtpStatus;	// 현재 상태코드
	private String updateStatus;
	private Integer refId;				// 프론트단에서 가져온 고유식별번호
}