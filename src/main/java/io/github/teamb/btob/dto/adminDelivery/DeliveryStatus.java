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
	
	READY("상품준비중"),
    L_SHIPPING("국제운송중"),
    L_WH("보세창고입고"),
    IN_CUSTOMS("통관진행중"),
    C_DONE("통관완료"),
    D_SHIPPING("국내배송중"),
    COMPLETE("배송완료");
	
	// 한글 뜻 저장
	private final String description;
}
