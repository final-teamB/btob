package io.github.teamb.btob.service.BizWorkflow;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;

public interface BizWorkflowServiceAdm {

		// 견적/주문/구매/결제 상태로직 동적 변경 처리 및 이력 추가
		int modifyEtpStatusAndLogHist(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) throws Exception;
		
}
