package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

/**
 *
 * 견적/주문/구매/결제 시 상태코드 업데이트 및 히스토리이력 추가 후 결과반환 DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class ApprovalDecisionResultDTO {

    private String systemId;				// 시스템ID
    private Integer orderId;				// 주문식별자
    private String ApprovalStatus;			// APPROVED(승인) REJECTED(반려) 타입
    private String requestUserNo;		    // 요청자
    private String rejtRsn;				    // 사유 (반려시)
    private String apprUserNo;			    // 승인자
    private String userId;
}
