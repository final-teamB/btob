package io.github.teamb.btob.mapper.bizworkflow;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpDynamicParamsDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusSelectDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusSeqDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusUpdateDTO;


@Mapper
public interface BizWorkflowMapper {
	
	// 동적쿼리 사용 시 적용할 테이블, 상태 컬럼, 식별자컬럼 확인
	EtpDynamicParamsDTO selectTargetParams(String systemId);
	
	// 견적/주문/구매/결제 상태코드 업데이트 시 요청 들어온 진행건의 현재 상태코드값
	String selectCurrentStatusByRefId(EtpStatusSelectDTO etpStatusSelectDTO);
	
	// 견적/주문/구매/결제 현재상태코드의 다음단계 상태코드 조회 ( 승인 )
	String selectNextStatus(EtpStatusSeqDTO etpStatusSeqDTO);
	
	// 견적/주문/구매/결제 현재상태코드의 반려 상태코드 조회 ( 반려 )
	String selectRejtStatus(String systemId);
	
	// 견적/주문/구매/결제 상태코드 업데이트
	Integer updateEtpStatus(EtpStatusUpdateDTO etpStatusUpdateDTO);
	
	// 견적/주문/구매/결제 이력 추가
	Integer insertEtpHist(ApprovalDecisionRequestDTO approvalDecisionRequestDTO);
}
