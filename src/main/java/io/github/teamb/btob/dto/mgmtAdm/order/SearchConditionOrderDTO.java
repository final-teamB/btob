package io.github.teamb.btob.dto.mgmtAdm.order;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 주문/구매 관리 검색 조회 DTO
 * 관련테이블 == TB_ORDER_MST
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class SearchConditionOrderDTO {

	private Integer orderId;		// 주문식별자
	private String orderNo;			// 주문번호
	private Integer quote_req_id;	// 견적서식별자
	private Integer userId;			// 주문자ID
	private String order_status;	// 주문,구매 상태 (통합?)
	private Integer cartId;			// 장바구니ID
	private LocalDateTime regDtime;	// 생성일시
	private Integer regId;			// 생성자
	private Integer useYn;			// 사용여부
	
	private Integer rownm;
}
