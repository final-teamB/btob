package io.github.teamb.btob.dto.payment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaymentRequestDTO {

	private Integer paymentId;      // 결제 PK
    private Integer dbOrderId;       // 주문 PK (TB_ORDER 참조)
    private String tossOrderId;
    private String orderNo;       // 주문 번호
    private String paymentNo;      // 결제 관리 번호
    private String payStep;        // 결제 단계 (FIRST: 1차, SECOND: 2차)
    private String paymentKey;     // PG사(토스 등) 결제 고유 키
    private String method;         // 결제 수단 (CARD, TRANSFER 등)
    private Integer amount;        // 결제 금액
    private String status;         // 결제 상태
    private String regId;          // 등록자 아이디 (session user id 등)
    private String useYn;          // 사용 여부 (기본값 'Y')
}