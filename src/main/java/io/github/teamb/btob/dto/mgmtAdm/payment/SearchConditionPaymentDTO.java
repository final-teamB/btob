package io.github.teamb.btob.dto.mgmtAdm.payment;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 결제 관리 검색 조회 DTO
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class SearchConditionPaymentDTO {

	private Integer paymentId;	// 결재식별자
	private Integer paymentNo;	// 결재번호
	private Integer orderId;	// 주문번호식별자
	private Integer orderNo;	// 주문번호
	private String payStep;		// 결재차수
	private String status;		// 결재상태
	private String payMethod;	// 결재수단
	private LocalDateTime regDtime;	// 생성일시
	private Integer regId;		// 생성자
	private String useYn;		// 사용여부 YN
}
