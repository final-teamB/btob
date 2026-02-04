package io.github.teamb.btob.dto.cart;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartItemInsertDTO {
    private int cartId;          // PK (시퀀스/auto)
    private int userId;          // 장바구니 소유자
    private int fuelId;          // 상품 ID (OIL_MST FK)

    private int totalQty;        // 총 수량
    private int totalPrice;      // 총 가격
    private String cartStatus;   // 장바구니 상태 (대기,승인)
    private int regId;
    private LocalDateTime regDtime;
    
    private int baseUnitPrc; // 기본 가격(oil join)
}
