package io.github.teamb.btob.dto.cart;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class CartDTO {

    private int cartId;             // cart_id
    private int userId;             // user_id
    private int fuelId;           	// fuel_id 상품(원유)
    private int totalQty;           // total_qty 총 수량
    private int totalPrice;         // total_price 총 가격
    private String cartStatus;      // cart_status 장바구니 상태
    private LocalDateTime regDtime; // reg_dtime 등록일
    private String regId;           // reg_id 등록자
    private LocalDateTime updDtime; // upd_dtime 수정일
    private String updId;           // upd_id 수정자
    private String useYn;           // use_yn 사용 여부
}
