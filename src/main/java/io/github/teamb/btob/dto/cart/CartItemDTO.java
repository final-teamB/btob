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
    private int targetProductPrc;
    private int targetProductAmt;
    // OIL
    private int fuelId;
    private String fuelNm;
    private String fuelCd;
    private String fuelCatCd;
    private String originCntryCd;
    private int baseUnitPrc;
    
    // ORDER
    private int orderId;
    private String orderStatus;
    
    // EST
    private String estNo;
    private String ctrtNm;
    private int targetTotalAmount;
    private int baseTotalAmount;
    private String estdtMemo;
    
    // 공통
    private String etpSttsNm;
    
    // USERS
    private int userNo;
    private String userName;
    private String phone;
    
    // COMPANIES
    private String companyCd;
    private String companyName;
    private String companyPhone;
    private String masterId;
    private String addrKor;
}