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
public class OrderDTO {

    private int orderId;                 // order_id
    private String orderNo;              // order_no
    private int quoteReqId;              // quote_req_id
    private int userId;                  // user_id
    private int cartId;                  // cart_id
    private String orderReqStatus;       // order_req_status 주문 승인 상태 (타사)
    private String purchaseReqStatus;    // purchase_req_status 구매 승인 상태 (자사)
    private String orderStatus;          // order_status 주문/구매 진행 상태
    private LocalDateTime regDtime;      // reg_dtime 등록일
    private String regId;                // reg_id 등록자
    private LocalDateTime updDtime;      // upd_dtime 수정일
    private String updId;                // upd_id 수정자
    private String useYn;                // use_yn 사용 여부 (Y/N)
 
}
