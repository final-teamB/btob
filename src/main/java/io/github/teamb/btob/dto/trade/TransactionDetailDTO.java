package io.github.teamb.btob.dto.trade;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class TransactionDetailDTO {
	private int docId;
    private String docNo;        // 영수증 번호 (REC-...)
    private String docTitle;     // 영수증 제목
    private int totalAmt;        // 총 결제 금액 (1차 + 2차 합계)
    private LocalDateTime regDtime; // 거래 일시

    /**
     * 1차 결제 금액 계산 (상품 대금)
     * 총액에서 하드코딩된 부대비용 750만원을 뺀 금액
     */
    public int getFirstPaymentAmt() {
        return this.totalAmt - 7500000;
    }
    
    public String getFormattedRegDtime() {
        if (this.regDtime == null) return "";
        return this.regDtime.format(java.time.format.DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm:ss"));
    }
    
    // 2. 업체/고객 정보 (JSP의 ${info} 객체 대응)
    private String companyName;  // 공급받는 자 (Buyer) 성명/업체명
    private String addrKor;      // 주소
    private String companyPhone;        // 연락처
    private String phone;        // 연락처
    private String userName;        // 담당자
   
}
