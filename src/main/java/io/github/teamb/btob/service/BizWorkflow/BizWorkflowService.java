package io.github.teamb.btob.service.BizWorkflow;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;

public interface BizWorkflowService {

	
	// 견적/주문/구매/결제 상태로직 동적 변경 처리 및 이력 추가
	int modifyEtpStatusAndLogHist(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) throws Exception;
	
	// 견적/주문/구매/결제 진행시 요청 들어온 진행건의 현재 상태코드 및 파라미터 검증
	String selectCurrentEtpStatusValidate(String systemId, Integer refId, Integer apprUserNo) throws Exception;
	
}