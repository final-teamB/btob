package io.github.teamb.btob.dto.cart;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItemDTO {
	// CART
    private int cartId;
    private int userId;
    private String fuelName;
    private int totalQty;
    private int totalPrice;
    
    // OIL
    private int fuelId;
    private String fuelNm;
    private String fuelCd;
    private String fuelCatCd;
    private String originCntryCd;
    private int baseUnitPrc;
}