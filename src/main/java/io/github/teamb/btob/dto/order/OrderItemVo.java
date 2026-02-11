package io.github.teamb.btob.dto.order;

import lombok.Data;

@Data
public class OrderItemVo {
    private String fuelName;          // 상품명
    private int totalQty;             // 수량
    private long baseUnitPrc;         // 기본 단가
    private long totalPrice;          // 바로주문 합계
    private long targetTotalAmount;   // 견적주문 합계
}