package io.github.teamb.btob.service.BizWorkflow.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.bizworkflow.BizCurrentSttsCdDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpDynamicParamsDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpHistInsertDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusSelectDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusUpdateDTO;
import io.github.teamb.btob.mapper.bizworkflow.BizWorkflowMapperAdm;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowServiceAdm;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class BizWorkflowServiceImplAdm implements BizWorkflowServiceAdm {

	private final BizWorkflowMapperAdm bizWorkflowMapperAdm;
	private final CommonService commonService;

	
	/**
	 * 
	 * 견적/주문/구매/결제 상태로직 동적 변경 처리 및 이력 추가
	 * @author GD
	 * @since 2026. 1. 28.
	 * @param approvalDecisionRequestDTO ( 의사결정요청 )
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
		String approvalStatus = approvalDecisionRequestDTO.getApprovalStatus();	// 승인,반려 타입
		String requestEtpStatus = approvalDecisionRequestDTO.getRequestEtpStatus(); // 변경요청 상태코드 
		String apprUserNo = approvalDecisionRequestDTO.getApprUserNo();	// 승인자
		String requestUserNo = approvalDecisionRequestDTO.getRequestUserNo(); // 요청자
		String userId = approvalDecisionRequestDTO.getUserId();
		Integer orderId = approvalDecisionRequestDTO.getOrderId();			// 히스토리 업데이트때 사용함, 추가로 무조건 바뀌어야하는 주문테이블 찾을때 사용함
		
		if ( !("APPROVED".equals(approvalStatus)) && 
			     !("REJECTED".equals(approvalStatus)) && 
			     !("COMPLETE".equals(approvalStatus)) ) { // 단순 확정 상태 추가
			    throw new Exception("유효하지 않은 요청입니다: " + approvalStatus);
		}
		
		// 파라미터 검증은 해당 메서드 안에서 처리됨
		// 현재 상태코드
		String currentEtpStatus = this.selectCurrentEtpStatusValidate(refId, userId);
		
		// 승인처리 시 다음 상태코드
		String nextEtpStatus = "";
		// 반려처리 시 상태코드
		String rejtEtpStatus = "";
		
		// 동적쿼리 값 가져오기
		EtpDynamicParamsDTO edDto = this.getTargetParams(systemId);
		
		int finalResult = 0;

	    if (approvalStatus.equals("APPROVED")) {
	        nextEtpStatus = bizWorkflowMapperAdm.selectNextStatus(currentEtpStatus);
	        
	        if (requestEtpStatus.equals(nextEtpStatus)) {
	            // 결과값을 finalResult에 할당
	            finalResult = processUpdateAndLog(edDto, requestEtpStatus, currentEtpStatus, refId, orderId, userId, approvalDecisionRequestDTO);
	        } else {
	            throw new Exception("상태 변경이 불가능한 단계이거나 데이터가 존재하지 않습니다.");
	        }

	    } else if (approvalStatus.equals("REJECTED")) {
	        rejtEtpStatus = bizWorkflowMapperAdm.selectRejtStatus(currentEtpStatus);
	        if (rejtEtpStatus == null) throw new Exception("현재 단계에서는 반려 처리를 할 수 없습니다.");
	        
	        if (requestEtpStatus.equals(rejtEtpStatus)) {
	            finalResult = processUpdateAndLog(edDto, requestEtpStatus, currentEtpStatus, refId, orderId, userId, approvalDecisionRequestDTO);
	        } else {
	            throw new Exception("상태 변경이 불가능한 단계입니다.");
	        }

	    } else if (approvalStatus.equals("COMPLETE")) {
	        // 단순 확정 로직
	        finalResult = processUpdateAndLog(edDto, requestEtpStatus, currentEtpStatus, refId, orderId, userId, approvalDecisionRequestDTO);
	    }

	    // 최종적으로 int 값을 반환 (이 부분이 빠져서 에러가 났던 것입니다)
	    return finalResult;
	}


	/**
	 * 1. 견적/주문/구매/결제 진행시 요청 들어온 진행건의 현재 상태코드 확인
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param refId			// 식별번호 ( orderId ) 로 통일합니다.
	 * @param userId		// 요청자
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private String selectCurrentEtpStatusValidate(Integer orderId, String userId) throws Exception {
		
		BizCurrentSttsCdDTO bdto = new BizCurrentSttsCdDTO();
		bdto.setOrderId(orderId);
		bdto.setUserId(userId);
		
		// 파라미터 검증
		if ( !(commonService.nullEmptyChkValidate(bdto)) ) {
			
			throw new Exception("파라미터 오류");
		};
		
		// 현재코드
		String currentEtpStatus = bizWorkflowMapperAdm.selectCurrentEtpSttsCd(bdto);
		
		if (currentEtpStatus == null || currentEtpStatus.isEmpty() ) {
			throw new Exception("유효하지 않는 요청입니다.");
		}
		
		return currentEtpStatus;
	}



	/**
	 * 
	 *  2. 여기서 상태코드를 업데이트할 테이블을 선택합니다. 
	 *  ESTIMATE	TB_EST_DOC		est_status		est_doc_id
	 *	ORDER		TB_ORDER_MST	order_status	order_id
	 *	PURCHASE	TB_ORDER_MST	order_status	order_id
	 *	PAYMENT		TB_PAYMENT_MST	status			payment_id
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param systemId
	 * @return etpDynamicParamsDTO ( target_table, target_status_col, target_pk_col )
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private EtpDynamicParamsDTO getTargetParams(String systemId) throws Exception {
		
		EtpDynamicParamsDTO etpDynamicParamsDTO = new EtpDynamicParamsDTO();
		etpDynamicParamsDTO = bizWorkflowMapperAdm.selectTargetParams(systemId);
		
		if ( etpDynamicParamsDTO == null ) {
			
			throw new Exception("유효하지 않은 시스템 코드입니다.");
		}
		
		return etpDynamicParamsDTO;
	}
	
	/**
	 * 
	 * 3. 상태코드 업데이트 동적쿼리 부분입니다.
	 * 각 시스템 ID에 맞는 테이블의 상태코드를 업데이트 처리할 세팅 DTO 부분입니다.
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param edDto			// 업데이트할 테이블, 업데이트할 상태코드컬럼, 조건절에서 사용할 식별자 ID컬럼 
	 * @param updateEtpStatus	// 업데이트할 상태코드
	 * @param currentEtpStatus	// 현재 상태코드
	 * @param refId
	 * @param userId
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private EtpStatusUpdateDTO getEtpStatusUpdateInfo(EtpDynamicParamsDTO edDto,
													String updateEtpStatus,
													String currentEtpStatus,
													Integer refId,
													String userId) {
		
		String targetTable = edDto.getTargetTable();					// 업데이트 대상 테이블
		String targetStatusCol = edDto.getTargetStatusCol();			// 업데이트 테이블 상태코드컬럼
		String targetPkCol = edDto.getTargetPkCol();					// 업데이트 테이블 식별자
		
		EtpStatusUpdateDTO etpStatusUpdateDTO = new EtpStatusUpdateDTO();

		etpStatusUpdateDTO.setTargetTable(targetTable);
		etpStatusUpdateDTO.setTargetStatusCol(targetStatusCol);
		etpStatusUpdateDTO.setTargetPkCol(targetPkCol);
		etpStatusUpdateDTO.setUpdateStatus(updateEtpStatus);
		etpStatusUpdateDTO.setCurrentEtpStatus(currentEtpStatus);
		etpStatusUpdateDTO.setRefId(refId);
		etpStatusUpdateDTO.setUserId(userId);
		
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
		
		// 무조건 히스토리 이력은 주문식별번호로 업데이트 됩니다.
		Integer refId = approvalDecisionRequestDTO.getOrderId();
		String requestEtpStatus = approvalDecisionRequestDTO.getRequestEtpStatus();
		String rejtRsn = approvalDecisionRequestDTO.getRejtRsn() != null 
			    ? approvalDecisionRequestDTO.getRejtRsn() 
			    : "";
		String apprUserNo = approvalDecisionRequestDTO.getApprUserNo();
		String requestUserNo = approvalDecisionRequestDTO.getRequestUserNo();
		String userId = approvalDecisionRequestDTO.getUserId();
		
		EtpHistInsertDTO histInsertDTO = new EtpHistInsertDTO();
		histInsertDTO.setRefId(refId);
		histInsertDTO.setApprUserNo(apprUserNo);
		histInsertDTO.setRequestEtpStatus(requestEtpStatus);
		histInsertDTO.setRejtRsn(rejtRsn);
		histInsertDTO.setRequestUserNo(requestUserNo);
		histInsertDTO.setUserId(userId);
		
		return histInsertDTO;
	}
	
	/**
	 * 상태 업데이트 및 이력 저장을 수행하는 공통 로직
	 */
	private int processUpdateAndLog(EtpDynamicParamsDTO edDto, String updateStatus, String currentStatus, 
	                                 Integer refId, Integer orderId, String userId, ApprovalDecisionRequestDTO requestDTO) throws Exception {
	    
	    // 1. 상태 업데이트 (TB_ORDER_MST 또는 TB_PAYMENT_MST)
	    int updateResult = bizWorkflowMapperAdm.updateEtpStatus(
	        this.getEtpStatusUpdate(edDto, updateStatus, currentStatus, refId, userId)
	    );
	    
	    // 1. 1 상태 업데이트 ( 무조건 어느 단계든 주문 테이블은 고정으로 진행 된다 )
	    EtpStatusUpdateDTO edto = new EtpStatusUpdateDTO();
	    edto.setRefId(orderId);
	    edto.setUpdateStatus(updateStatus);

	    bizWorkflowMapperAdm.fixUpdateOrderStatus(edto);
	    
	    if (updateResult <= 0) {
	        throw new Exception("업데이트에 실패했습니다. (이미 처리되었거나 유효하지 않은 상태)");
	    }

	    // 2. 이력 추가 (TB_ETP_HIST)
	    int histResult = bizWorkflowMapperAdm.insertEtpHist(this.getEtpHistInsert(requestDTO));
	    
	    if (histResult <= 0) {
	        throw new Exception("이력 추가 중 오류가 발생했습니다.");
	    }
	    
	    return histResult;
	}
}
