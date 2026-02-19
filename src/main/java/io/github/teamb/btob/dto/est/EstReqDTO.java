package io.github.teamb.btob.dto.est;

import java.util.List;

import lombok.Data;

//요청 전체를 담는 DTO
@Data
public class EstReqDTO {
	 private List<EstItemDTO> itemList;
	 private int baseTotalAmount;
	 private int targetTotalAmount;
	 private String estdtMemo;
	 private String ctrtNm;
	 private String companyName;
	 private String companyPhone;
	 private String requestUserId;
	 private String regId;


	//개별 품목 정보를 담는 DTO
    @Data
    public static class EstItemDTO {
        private int cartId;
        private String fuelNm;
        private int totalQty;
        private int totalPrice;
        private int baseUnitPrc;        
        private int targetProductPrc;
        private int targetProductAmt;
    }

}
