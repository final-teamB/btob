package io.github.teamb.btob.dto.statistics;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum StatisticsType {
	ORDER("주문 통계"),
    DELIVERY("배송 통계"),
    USER("사용자 통계"),
    PRODUCT("상품 통계");
	
	private final String description;
}
