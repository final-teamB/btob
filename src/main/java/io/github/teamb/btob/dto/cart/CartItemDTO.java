package io.github.teamb.btob.dto.cart;

import java.time.LocalDateTime;

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
    private String userId;
    private String orderNo;
    private int totalQty;
    private int totalPrice;
    private String cartStatus;
    private LocalDateTime regDtime;
    private String regId;
    private String useYn;
    
    // OIL
    private int fuelId;
    private String fuelNm;
    private String fuelCd;
    private String fuelCatCd;
    private String originCntryCd;
    private int baseUnitPrc;
    
    // ORDER
    private String orderStatus;
    
    // USERS
    private String userName;
    private String phone;
    
    // COMPANIES
    private String companyCd;
    private String companyName;
    private String bizNumber;
    private String masterName;
}