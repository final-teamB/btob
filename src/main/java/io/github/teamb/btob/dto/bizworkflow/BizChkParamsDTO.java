package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

@Data
public class BizChkParamsDTO {

	Integer orderId;		// 주문식별번호
	Integer estId;			// 견적식별번호 ( 주문테이블 )
	Integer estDocId;		// 견적식별번호 ( 견적서테이블 )
	Integer paymentId;		// 결제식별번호 ( 결제테이블 )

	String userId;			// 요청자아이디
	String systemId;		// 시스템아이디

	// TB_ETP_STTS_CD
	String etpSttsCd;		// 상태코드

	// 권한체크
	String userType;		// 사용자타입
	String companyCd;		// 사용자회사


	// 제품 재고 반품 시
	Integer fuelId;			// 상품식별자
	Integer totalQty;		// 상품주문수량
}
