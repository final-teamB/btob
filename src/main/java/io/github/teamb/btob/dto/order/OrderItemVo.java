package io.github.teamb.btob.dto.order;

import lombok.Data;

@Data
public class OrderItemVo {
    private String fuelName;          // 상품명
    private int totalQty;             // 수량
    private int baseUnitPrc;         // 기본 단가
    private int totalPrice;          // 바로주문 합계
    private int targetProductPrc;    // 희망 단가
    private int targetProductAmt;    // 희망 단가 합계
    private int targetTotalAmount;   // 견적주문 합계
}