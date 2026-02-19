package io.github.teamb.btob.dto.trade;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

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
    private String companyName;     // 업체명
    private Integer orderId;        // order_id
    private String orderNo;         // order_no
    private String orderStatus;     // 주문상태
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDtime; // 등록 일시
    private String regId;
    private String useYn;
    
 
    
    // 검색,필터
    private String keyword;
    private String tradeType;
}
