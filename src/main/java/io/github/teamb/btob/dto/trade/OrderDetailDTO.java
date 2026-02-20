package io.github.teamb.btob.dto.trade;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class OrderDetailDTO {
    // 1. 주문 마스터 (TB_ORDER_MST)
    private int orderId;
    private String orderNo;
    private String orderStatus;
    private LocalDateTime regDtime;

    // 2. 업체 및 요청자 정보 (TB_COMPANIES, TB_USERS)
    private String companyName;
    private String companyPhone;
    private String addrKor;
    private String userNo;
    private String userId;
    private String userName;
    private String phone;

    // 3. 주문 품목 리스트 (TB_CART + TB_OIL_MST)
    private List<OrderItemDTO> itemList;
    
    @Data
    public static class OrderItemDTO {
    	private int cartId;
    	private String fuelNm;
    	private int totalQty;
    	private int totalPrice; // 확정 단가 * 수량 (실제 결제/계약 금액)
    	private int baseUnitPrc; // 기준 단가 (참고용)
    }
}

