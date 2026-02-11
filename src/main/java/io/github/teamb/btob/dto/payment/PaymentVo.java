package io.github.teamb.btob.dto.payment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor 
@AllArgsConstructor
public class PaymentVo {
    private int paymentId;
    private int amount;
    private String method;         // 결제 수단
    private String status;         // 결제 상태
}
