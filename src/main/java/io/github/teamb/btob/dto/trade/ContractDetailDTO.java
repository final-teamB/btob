package io.github.teamb.btob.dto.trade;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import lombok.Data;

@Data
public class ContractDetailDTO {
    // 1. 문서 관련 (doc 객체에 대응)
	private int docId;       
    private String docNo;        // 계약번호 (CON-...)
    private String docTitle;     // 계약명
    private int totalAmt;       // 총 계약 금액 (VAT 포함)   
    private LocalDateTime dueDate;        // 납기 기한
    private String docContent;   // 특약 사항
    private LocalDateTime regDtime;       // 생성일시

    public String getFormattedDueDate() {
        if (this.dueDate == null) return "";
        return this.dueDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
    }
    
    // 2. 업체 정보 (info 객체에 대응)
    private String companyName;
    private String addrKor;
    private String companyPhone;
    private String userName;
    private String phone;

    // 3. 품목 리스트 (itemList 객체에 대응)
    private List<ContractItemDTO> itemList;


	@Data
	public static class ContractItemDTO {
		private int cartId;
		private String fuelNm;         // 품목명
	    private int totalQty;          // 수량
	    private int totalPrice;        // 합계 금액
	    private int targetProductPrc;  // 희망 단가
	    private int targetProductAmt;  // 희망 합계 금액
	    private int baseUnitPrc;       // 기본단가
	    
	 }
}
