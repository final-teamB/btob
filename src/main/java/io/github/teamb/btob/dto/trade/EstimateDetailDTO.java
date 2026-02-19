package io.github.teamb.btob.dto.trade;

import java.util.List;

import lombok.Data;

@Data
public class EstimateDetailDTO {
    // 1. 견적 마스터 (TB_EST_DOC & TB_ORDER_MST)
    private int orderId;
    private String orderNo;
    private int estDocId;
    private String estNo;
    private String ctrtNm;
    private String estdtMemo;
    private int baseTotalAmount;
    private int targetTotalAmount;
    private String orderStatus;

    // 2. 업체 및 요청자 정보 (TB_COMPANIES & TB_USERS)
    private String companyName;
    private String companyPhone;
    private String addrKor;
    private String userName;
    private String phone;

    // 3. 견적 품목 상세 리스트 (TB_CART & TB_OIL_MST)
    private List<EstimateItemDTO> itemList;
    
    @Data
    public static class EstimateItemDTO {
    	private int cartId;
    	private String fuelNm;
    	private int totalQty;
    	private int baseUnitPrc;      // 기존 단가
    	private int targetProductPrc; // 희망 단가
    	private int targetProductAmt; // 희망 총액 (수량 * 희망단가)
    }
}

