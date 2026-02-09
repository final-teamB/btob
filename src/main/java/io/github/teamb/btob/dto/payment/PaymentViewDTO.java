package io.github.teamb.btob.dto.payment;

import java.util.List;

import lombok.Data;

@Data
public class PaymentViewDTO {
    // 주문 기본 정보
    private String orderNo;
    private int totalQty;
    private int totalPrice;
    private String fuelNm;
    private int userNo;
    private String userId;

    // 회사 및 사업자 정보 (Read-Only 출력용)
    private String userName;
    private String phone;
    private String companyCd;
    private String companyName;
    private String bizNumber;
    private String masterName;
    private String companyPhone;
    private String addrKor;
    private String addrEng;
    private String zipCode;
    private String customsNum; // 통관번호가 필요한 경우 포함
    
    private List<PaymentItemDTO> itemList;
    
    @Data
    public class PaymentItemDTO {
        private String fuelNm;
        private int totalQty;
        private long totalPrice; // 품목별 소계
        private int baseUnitPrc; // 단가
        private int targetProductPrc; // 희망단가
        private int apprUnitPrc; // // 최종 적용 단가
    }
}
