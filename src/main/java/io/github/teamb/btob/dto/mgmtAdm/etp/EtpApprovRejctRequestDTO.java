package io.github.teamb.btob.dto.mgmtAdm.etp;

import lombok.Data;

/**
 * 
 * 견적/주문/구매/결제 관리 견적승인반려, 구매승인반려 DTO
 * @author GD
 * @since 2026. 2. 12.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 12.  GD       최초 생성
 */
@Data
public class EtpApprovRejctRequestDTO {

	private String systemId;	// 시스템아이디
	private String userId;		// 사용자 아이디
	private String approvalStatus; // 승인,반려 타입 , APPROVED, REJECTED, COMPLETE
	private String rejtRsn;		// 반려 사유
	private Integer orderId;		// 견적요청이든 주문이든 무조건 주문식별자는 생긴다
}
