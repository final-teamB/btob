package io.github.teamb.btob.service.BizWorkflow.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpDynamicParamsDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpHistInsertDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusSelectDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusSeqDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusUpdateDTO;
import io.github.teamb.btob.mapper.bizworkflow.BizWorkflowMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class BizWorkflowServiceImpl implements BizWorkflowService{
	
	private final BizWorkflowMapper bizWorkflowMapper;
	private final CommonService commonService;

	
	/**
	 * 
	 * 견적/주문/구매/결제 상태로직 동적 변경 처리 및 이력 추가
	 * @author GD
	 * @since 2026. 1. 28.
	 * @param etpStatusDTO ( systemId(ESTIMATE,ORDER), refId(ets_id) )
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 28.  GD       최초 생성
	 * @throws Exception 
	 */
	@Override
	public int modifyEtpStatusAndLogHist(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) throws Exception {
		
		// request값
		String systemId = approvalDecisionRequestDTO.getSystemId();				// 시스템 ID
		Integer refId = approvalDecisionRequestDTO.getRefId();					// 식별번호
		String approvalStatus = approvalDecisionRequestDTO.getApprovalStatus();	// 승인,반려 요청
		String requestEtpStatus = approvalDecisionRequestDTO.getRequestEtpStatus(); // 변경요청 상태코드 
		Integer apprUserNo = approvalDecisionRequestDTO.getApprUserNo();	// 요청자
		
		if ( !("APPROVED".equals(approvalStatus)) && !("REJECTED".equals(approvalStatus)) ) {
			
		    throw new Exception("유효하지 않은 요청입니다: " + approvalStatus);
		}
		
		// 파라미터 검증은 해당 메서드 안에서 처리됨
		// 현재 상태코드
		String currentEtpStatus = this.selectCurrentEtpStatusValidate(systemId, refId, apprUserNo);
		
		EtpStatusSeqDTO etpStatusSeqDTO = new EtpStatusSeqDTO();
		etpStatusSeqDTO.setSystemId(systemId);
		etpStatusSeqDTO.setCurrentEtpStatus(currentEtpStatus);
		
		// 승인처리 시 다음 상태코드
		String nextEtpStatus = bizWorkflowMapper.selectNextStatus(etpStatusSeqDTO);
		// 반려처리 시 상태코드
		String rejtEtpStatus = bizWorkflowMapper.selectRejtStatus(systemId);
		
		// 동적쿼리 값 가져오기
		EtpDynamicParamsDTO edDto = this.getTargetParams(systemId);
		
		int result = 0;
		
		if (approvalStatus.equals("APPROVED")) {
			if (requestEtpStatus.equals(nextEtpStatus)) {
				// 업데이트
			    result = bizWorkflowMapper.updateEtpStatus(this.getEtpStatusUpdate(edDto, 
			    																	requestEtpStatus, 
			    																	currentEtpStatus));
			    if ( result > 0) {
			    	// 히스토리 추가
			    	this.getEtpHistInsert(approvalDecisionRequestDTO);
			    } else {
			    	throw new Exception("이력 추가 시 오류가 발생했습니다.");
			    }
			} else {
				throw new Exception("상태 변경이 불가능한 단계이거나 데이터가 존재하지 않습니다.");
			}
		} else if (approvalStatus.equals("REJECTED")) {
			if (requestEtpStatus.equals(rejtEtpStatus)) {
				// 업데이트
			    result = bizWorkflowMapper.updateEtpStatus(this.getEtpStatusUpdate(edDto, 
			    																	requestEtpStatus,
			    																	currentEtpStatus));
			    if ( result > 0) {
			    	// 히스토리 추가
			    	this.getEtpHistInsert(approvalDecisionRequestDTO);
			    } else {
			    	throw new Exception("이력 추가 시 오류가 발생했습니다.");
			    }
			} else {
				throw new Exception("상태 변경이 불가능한 단계이거나 데이터가 존재하지 않습니다.");
			}
		} 

	    return result;
	}


	/**
	 * 
	 * 견적/주문/구매/결제 진행시 요청 들어온 진행건의 현재 상태코드 및 파라미터 검증
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param refId ( 고유식별자 )
	 * @return boolean
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 * @throws Exception 
	 */
	@Override
	public String selectCurrentEtpStatusValidate(String systemId, Integer refId, Integer apprUserNo) throws Exception {
		
		Map<String, Object> params = new HashMap<>();
		params.put("refId", refId);
		params.put("systemId", systemId);
		params.put("apprUserNo", apprUserNo);
		
		// 파라미터 검증
		if ( !(commonService.nullEmptyChkValidate(params)) ) {
			
			throw new Exception("파라미터 오류");
		};
		
		
		// 동적쿼리 값 가져오기
		EtpDynamicParamsDTO eDto = this.getTargetParams(systemId);
		String targetTable = eDto.getTargetTable();
		String targetPkCol = eDto.getTargetPkCol();
		
		// 해당 식별번호 및 요청자 유무 검증
		EtpStatusSelectDTO etpStatusSelectDTO = new EtpStatusSelectDTO();
		etpStatusSelectDTO.setTargetTable(targetTable);
		etpStatusSelectDTO.setTargetPkCol(targetPkCol);
		etpStatusSelectDTO.setRefId(refId);
		etpStatusSelectDTO.setApprUserNo(apprUserNo);

		String currentEtpStatus = bizWorkflowMapper.selectCurrentStatusByRefId(etpStatusSelectDTO);
		
		if (currentEtpStatus == null || currentEtpStatus.isEmpty() ) {
			
			throw new Exception("유효하지 않는 요청입니다.");
		}
		
		return currentEtpStatus;
	}


	/**
	 * 
	 * 동적쿼리 세팅에 필요한 값 가져오는 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param systemId
	 * @return etpDynamicParamsDTO ( target_table, target_status_col, target_pk_col )
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	private EtpDynamicParamsDTO getTargetParams(String systemId) throws Exception {

		EtpDynamicParamsDTO etpDynamicParamsDTO = new EtpDynamicParamsDTO();
		etpDynamicParamsDTO = bizWorkflowMapper.selectTargetParams(systemId);
		
		if ( etpDynamicParamsDTO == null ) {
			
			throw new Exception("유효하지 않은 시스템 코드입니다.");
		}
		
		return etpDynamicParamsDTO;
	}
	
	/**
	 * 
	 * 업데이트에 사용하는 동적쿼리 및 파라미터값 설정 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param edDto
	 * @param currentEtpStatus == 현재상태코드
	 * @return etpStatusUpdateDTO
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	private EtpStatusUpdateDTO getEtpStatusUpdate(EtpDynamicParamsDTO edDto,
													String requestEtpStatus,
													String currentEtpStatus) {
		
		String targetTable = edDto.getTargetTable();					// 업데이트 대상 테이블
		String targetStatusCol = edDto.getTargetStatusCol();			// 업데이트 테이블 상태코드컬럼
		String targetPkCol = edDto.getTargetPkCol();					// 업데이트 테이블 식별자
		
		EtpStatusUpdateDTO etpStatusUpdateDTO = new EtpStatusUpdateDTO();

		etpStatusUpdateDTO.setTargetTable(targetTable);
		etpStatusUpdateDTO.setTargetStatusCol(targetStatusCol);
		etpStatusUpdateDTO.setTargetPkCol(targetPkCol);
		etpStatusUpdateDTO.setUpdateStatus(requestEtpStatus);
		etpStatusUpdateDTO.setCurrentEtpStatus(currentEtpStatus);
		
		return etpStatusUpdateDTO;
	}
	
	/**
	 * 
	 * 히스토리 이력 추가 DTO 값 설정 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param approvalDecisionRequestDTO
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	private EtpHistInsertDTO getEtpHistInsert(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) {
		
		Integer refId = approvalDecisionRequestDTO.getRefId();
		String requestEtpStatus = approvalDecisionRequestDTO.getRequestEtpStatus();
		String rejtRsn = approvalDecisionRequestDTO.getRejtRsn() != null 
			    ? approvalDecisionRequestDTO.getRejtRsn() 
			    : "";
		Integer apprUserNo = approvalDecisionRequestDTO.getApprUserNo();
		Integer requestUserNo = approvalDecisionRequestDTO.getRequestUserNo();
		
		EtpHistInsertDTO histInsertDTO = new EtpHistInsertDTO();
		histInsertDTO.setRefId(refId);
		histInsertDTO.setApprUserNo(apprUserNo);
		histInsertDTO.setRequestEtpStatus(requestEtpStatus);
		histInsertDTO.setRejtRsn(rejtRsn);
		histInsertDTO.setRequestUserNo(requestUserNo);
		
		return histInsertDTO;
	}
}
