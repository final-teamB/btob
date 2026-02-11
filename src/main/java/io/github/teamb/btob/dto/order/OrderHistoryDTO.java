package io.github.teamb.btob.dto.order;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class OrderHistoryDTO {
	// 주문 마스터 정보
    private int orderId;
    private String orderNo;
    private String productName;
    private int amount;
    private String orderStatus;            // 주문 상태 (pm001, pm002, pm003 등)
    private String regId;
    private LocalDateTime regDtime;  // 주문일 (reg_dtime)

    // 배송 정보 (TB_DELIVERY)
    private int deliveryId;
    private String deliveryStatus;    // READY, L_SHIPPING, IN_CUSTOMS 등
 
    // UI용 상태 명칭 (직관적인 한글 표시를 위해)
    private String statusNm;
    private String deliveryStatusNm;
    
    // 검색,필터
    private String keyword;
}
