package io.github.teamb.btob.dto.order;

import java.time.LocalDateTime;
import java.util.List;

import io.github.teamb.btob.dto.payment.PaymentVo;
import lombok.Data;

@Data
public class OrderVoDTO {
	// 1. 주문 기본 정보 (TB_ORDER_MST 매핑)
    private int orderId;            // 주문 고유번호
    private String orderNo;         // 주문번호 (표시용)
    private String orderStatus;     // 주문상태 코드 (pm001, pm002...)
    private String statusNm;        // 주문상태 명칭 (결제대기, 검수중...)
    private LocalDateTime regDtime; // 주문일시
    private int amount;            // 1차 총 결제 금액
    
    // 2. 배송지 정보
    private String userName;        // 담당자명
    private String companyName;     // 회사명
    private String phone;           // 연락처
    private String zipCode;         // 우편번호
    private String addrKor;         // 기본 주소
    private String addrDetail;      // 상세 주소
    
    // 3. 상품 목록 (1:N 관계)
    // JSP의 <c:forEach var="item" items="${order.itemList}"> 에 대응
    private List<OrderItemVo> itemList;
    
    // 4. 2차 결제 정보 (1:1 관계)
    // JSP의 ${order.secondPay.amount} 에 대응
    private PaymentVo firstPay;
    private PaymentVo secondPay;
}
