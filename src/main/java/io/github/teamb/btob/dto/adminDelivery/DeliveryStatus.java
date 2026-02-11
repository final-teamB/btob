package io.github.teamb.btob.dto.adminDelivery;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/*
	배송 상태 정의
	tb_delivery 테이블의 delivery_status 칼럼과 매핑
 */

@Getter
@RequiredArgsConstructor
public enum DeliveryStatus {
	
	dv001("상품준비중"),
	dv002("국제운송중"),
	dv003("보세창고입고"),
	dv004("통관진행중"),
	dv005("통관완료"),
	dv006("국내배송중"),
	dv007("배송완료");
	
	// 한글 뜻 저장
	private final String description;
}
