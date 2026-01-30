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
    private int cartId;
    private int fuelId;
    private String fuelName;
    private int totalQty;
    private int totalPrice;
}