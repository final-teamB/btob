package io.github.teamb.btob.dto.payment;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTO {
	private int paymentId;      // payment_id (PK)
    private String paymentNo;       // payment_no (결제번호)
    private int orderId;        // order_id (주문/견적 마스터 ID)
    
    /**
     * payStep: 결제 단계
     * "FIRST" (1차), "SECOND" (2차)
     */
    private String payStep;         
    private String paymentKey;         
    private String method;         
    private int amount;
    private String status; // 결제 상태          
    
    private LocalDateTime regDtime; // reg_dtime
    private String regId;           // reg_id
    private LocalDateTime updDtime; // upd_dtime
    private String updId;           // upd_id
    private String useYn;    
}
