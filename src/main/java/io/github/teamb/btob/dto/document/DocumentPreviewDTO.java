package io.github.teamb.btob.dto.document;

import java.time.LocalDateTime;
import java.util.List;

import io.github.teamb.btob.dto.cart.CartItemDTO;
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

public class DocumentPreviewDTO {
	private int docId;              // doc_id
    private String docNo;			// doc_no
    private String docType;			// doc_type  QUOTE / CONTRACT / TRANSACTION
    private int ownerUserId;        // owner_user_id내부 로직용
    private String userName;        // ownerUserName 화면 표시용
    private String memo;  			// memo
    private LocalDateTime regDtime; // reg_dtime
    
    // Order 연동
    private int orderId;			
    private String orderNo;			// 주문 코드
    private String orderStatus;     // 주문 상태()

    private List<CartItemDTO> cartItems; // 장바구니 목록
}
