package io.github.teamb.btob.dto.trade;

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
public class TradePendingDTO {
	private int userNo;             // 사원 번호
    private String userId;          // 로그인 ID
    private String userName;        // 이름
    private String phone;           // 전화번호
    private int orderId;            // order_id
    private String orderNo;         // order_no
    private int quoteReqId;         // quote_req_id
    private String orderStatus;     // 주문상태
    private String cartStatus;       
    private LocalDateTime regDtime; // 등록 일시
    private String regId;
    private LocalDateTime updDtime; 
    private String updId; 
    private String useYn;
    
    private int cartId;
    private int totalQty;
    private int totalPrice;
    
    // OIL
    private String fuelNm;
    private int baseUnitPrc;
    
    // COMPANIES
    private String companyCd;
    private String companyName;
    private String addrKor;
    private String bizNumber;
    private String masterName;
    
    // 검색,필터
    private String keyword;
    private String tradeType;
}
