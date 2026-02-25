package io.github.teamb.btob.service.BizWorkflow.impl;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.*;
import io.github.teamb.btob.dto.mgmtAdm.product.UpdateProductCurrVolDTO;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.mapper.bizworkflow.BizWorkflowMapperAdm;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowServiceAdm;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class BizWorkflowServiceImplAdm implements BizWorkflowServiceAdm {

	private final BizWorkflowMapperAdm bizWorkflowMapperAdm;
	private final CommonService commonService;
	private final ProductManagementService productManagementService;
	private final LoginUserProvider loginUserProvider;

	
	/**
	 * 
	 * 견적/주문/구매/결제 상태로직 동적 변경 처리 및 이력 추가
	 * @author GD
	 * @since 2026. 1. 28.
	 * @param approvalDecisionRequestDTO ( 의사결정요청 )		systemId는 현재 주문 상태의 systemId 값으로 가져와야합니다.
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 28.  GD       최초 생성
	 * @throws Exception 
	 */
	@Override
	public ApprovalDecisionResultDTO modifyEtpStatusAndLogHist(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) throws Exception {

		if ( !commonService.nullEmptyChkValidate(approvalDecisionRequestDTO) ) {
			throw new Exception("승인/반려 요청 파라미터 오류입니다.");
		}
		
		if ( !(commonService.nullEmptyChkValidate(loginUserProvider.getLoginUserId())) ) {
			throw new Exception("로그인 사용자가 존재하지 않습니다.");
		}
		
		// 테스트 임시 컨텍스트나 세션에서 로그인 사용자 가져와야함
		// String loginUserId = "admin@gmail.com";
		String loginUserId = loginUserProvider.getLoginUserId();

		String currentSystemId = approvalDecisionRequestDTO.getSystemId();				// 현재 시스템 ID
		Integer orderId = approvalDecisionRequestDTO.getOrderId();						// 식별번호는 주문 식별자만 받습니다.
		String approvalStatus = approvalDecisionRequestDTO.getApprovalStatus();			// APPROVED(승인) REJECTED(반려) 타입
		String userId = approvalDecisionRequestDTO.getUserId();							// 요청자
		String requestUserNo = approvalDecisionRequestDTO.getRequestUserNo(); 			// 요청자
		String rejtRsn = approvalDecisionRequestDTO.getRejtRsn() != null				// 반려사유
				? approvalDecisionRequestDTO.getRejtRsn()
				: "";

		if ( !("APPROVED".equals(approvalStatus)) &&
			     !("REJECTED".equals(approvalStatus)) ) {

			    throw new Exception("유효하지 않은 요청입니다: " + approvalStatus);
		}

		// 현재 상태코드
		String currentEtpStatus = this.selectCurrentEtpStatusValidate(orderId, currentSystemId, userId);

		ApprovalDecisionResultDTO resultDTO = new ApprovalDecisionResultDTO();

		// 승인 단계
		if (approvalStatus.equals("APPROVED")) {

			// 승인처리 시 다음 시스템 코드와 상태코드 값
			BizChkParamsDTO nxtDto = bizWorkflowMapperAdm.selectNextStatus(currentEtpStatus);
			String nextSystemId = nxtDto.getSystemId();		// 다음 시스템 코드
			String nextEtpStatus = nxtDto.getEtpSttsCd();	// 다음 상태코드

			// 권한 체크
			if (!this.canUseStep(requestUserNo, loginUserId, nextSystemId, nextEtpStatus)) {
			    throw new Exception("해당 단계를 승인할 권한이 없습니다. (사용자: " + loginUserId + ")");
			}

			// 다음 상태코드로 변경할 테이블 서치
			EtpDynamicParamsDTO edDto = this.getTargetParams(nextSystemId);

			approvalDecisionRequestDTO.setRequestEtpStatus(nextEtpStatus);		// 히스토리 이력때 사용 ( 다음 상태 코드 )
			approvalDecisionRequestDTO.setApprUserNo(loginUserId);				// 히스토리 이력때 사용 ( 승인자 ) canUseStep 에서 권한체크했음

			// 업데이트 및 히스토리 이력 등록
			int finalResult = processUpdateAndLog(edDto,
									nextEtpStatus,
									currentEtpStatus,
									orderId,
									nextSystemId,
									userId,
									approvalDecisionRequestDTO);

			if ( finalResult > 0 ) {

				// 반환값 담아주기
				resultDTO.setSystemId(nextSystemId);
				resultDTO.setOrderId(orderId);
				resultDTO.setApprovalStatus(approvalStatus);
				resultDTO.setApprUserNo(loginUserId);
				resultDTO.setRequestUserNo(requestUserNo);
				resultDTO.setRejtRsn(rejtRsn);
				resultDTO.setUserId(userId);
			} else {
				throw new Exception("업데이트 및 히스토리 이력 등록에 실패하였습니다.");
			}

		// 반려 단계
		} else if (approvalStatus.equals("REJECTED")) {

			// 반려처리 시 상태코드 값
			String rejtEtpStatus = bizWorkflowMapperAdm.selectRejtStatus(currentEtpStatus);
			
			// 권한 체크
			if (!this.canUseStep(requestUserNo, loginUserId, currentSystemId, rejtEtpStatus)) {
			    throw new Exception("해당 단계를 반려할 권한이 없습니다. (사용자: " + loginUserId + ")");
			}

			// 다음 상태코드로 변경할 테이블 서치
			EtpDynamicParamsDTO edDto = this.getTargetParams(currentSystemId);
			
			System.out.println("BizWrk 현재 상태코드 확인합니다. : " + currentEtpStatus);
			System.out.println("BizWrk 현재 시스템 ID 확인합니다. : " + currentSystemId);
			System.out.println("BizWrk 반려 상태 코드 확인합니다. : " + rejtEtpStatus);
			approvalDecisionRequestDTO.setRequestEtpStatus(rejtEtpStatus);		// 히스토리 이력때 사용 ( 다음 상태 코드 )
			approvalDecisionRequestDTO.setApprUserNo(loginUserId);				// 히스토리 이력때 사용 ( 승인자 ) canUseStep 에서 권한체크했음

			// 업데이트 및 히스토리 이력 등록
			int finalResult = processUpdateAndLog(edDto,
					rejtEtpStatus,
					currentEtpStatus,
					orderId,
					currentSystemId,
					userId,
					approvalDecisionRequestDTO);

			if ( finalResult > 0 ) {

				// 제품 재고 회수
				// 제품식별자, 주문수량
				List<BizChkParamsDTO> bizparamdto = bizWorkflowMapperAdm.selectReturnProductIdAndQty(orderId);

				if (bizparamdto == null || bizparamdto.isEmpty()) {

					throw new RuntimeException("회수할 제품이 없습니다.");
				}

				for ( BizChkParamsDTO bdto : bizparamdto ) {

					UpdateProductCurrVolDTO volDTO = new UpdateProductCurrVolDTO();

					volDTO.setFuelId(bdto.getFuelId());
					volDTO.setOrderQty(bdto.getTotalQty());
					// 반품 상태는 UP
					volDTO.setRequestType("UP");
					productManagementService.modifyProductCurrVol(volDTO);
				}

				// 반환값 담아주기
				resultDTO.setSystemId(currentSystemId);
				resultDTO.setOrderId(orderId);
				resultDTO.setApprovalStatus(approvalStatus);
				resultDTO.setApprUserNo(loginUserId);
				resultDTO.setRequestUserNo(requestUserNo);
				resultDTO.setRejtRsn(rejtRsn);
				resultDTO.setUserId(userId);
			} else {
				throw new RuntimeException("업데이트 및 히스토리 이력 등록에 실패하였습니다.");
			}
		}

		return resultDTO;
	}

	/**
	 * 2. 처리 권한 확인하기
	 * @param requestUserNo		// 요청자ID
	 * @param loginUserId		// 로그인사용자ID
	 * @param nextSystemId		// 시스템다음단계ID
	 * @param nextEtpStatus		// 다음상태코드단계
	 * @return boolean
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 16.  GD       최초 생성
	 */
	private boolean canUseStep( String requestUserNo,
								String loginUserId,
							   	String nextSystemId,
							   	String nextEtpStatus) {

		// 1. 요청자의 타입과 회사 코드 확인
		String requestCpcd = bizWorkflowMapperAdm.selectUserTypeChk(requestUserNo).getCompanyCd();
		// 2. 로그인사용자 타입과 회사코드 확인
		String loginUserCp = bizWorkflowMapperAdm.selectUserTypeChk(loginUserId).getCompanyCd();
		String loginUserType = bizWorkflowMapperAdm.selectUserTypeChk(loginUserId).getUserType();

		// 1차 결제완료, 2차 결제완료
		boolean isPaymentStep =
				"PAYMENT".equals(nextSystemId) &&
						("pm002".equals(nextEtpStatus) || "pm004".equals(nextEtpStatus));


		// ADMIN 은 전부 허용
		if ("ADMIN".equals(loginUserType)) {
			return true;
		}

		// USER 권한 ( 같은 회사 체크 )
		if ("USER".equals(loginUserType) && requestCpcd.equals(loginUserCp)) {
			// 주문요청
			if ("ORDER".equals(nextSystemId) && "od001".equals(nextEtpStatus)) {
				return true;
			}
			// 구매요청
			if ("PURCHASE".equals(nextSystemId) && "pr001".equals(nextEtpStatus)) {
				return true;
			}
			// 1차 결제완료, 2차 결제완료
			if (isPaymentStep) {
				return true;
			}
			return false;
		}

		// MASTER 권한 ( 같은 회사 체크 )
		if ("MASTER".equals(loginUserType) && requestCpcd.equals(loginUserCp)) {
			// 주문요청, 주문승인, 주문반려
			if ("ORDER".equals(nextSystemId)) {
				return true;
			}
			// 구매요청
			if ("PURCHASE".equals(nextSystemId) && "pr001".equals(nextEtpStatus)) {
				return true;
			}
			// 1차 결제완료, 2차 결제완료
			if (isPaymentStep) {
				return true;
			}
			return false;
		}

		// 그 밖의 타입은 기본적으로 불가
		return false;
	}


	/**
	 * 1. 견적/주문/구매/결제 진행시 요청 들어온 진행건의 현재 상태코드 확인
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param orderId			// 주문식별번호 ( orderId )
	 * @param currentSystemId	// 현재 상태코드
	 * @param userId			// 요청자
	 * @return currentEtpStatus	// 현재 상태코드
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private String selectCurrentEtpStatusValidate(Integer orderId,
												  String currentSystemId,
												  String userId) throws Exception {
		
		BizChkParamsDTO bdto = new BizChkParamsDTO();
		bdto.setOrderId(orderId);
		bdto.setSystemId(currentSystemId);
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
	 *  3. 여기서 상태코드 업데이트가 필요한 추가 테이블을 선택합니다.
	 *  ( TB_ORDER_MST는  필수)
	 *  ESTIMATE	TB_EST_DOC		est_status		est_doc_id
	 *	ORDER		TB_ORDER_MST	order_status	order_id
	 *	PURCHASE	TB_ORDER_MST	order_status	order_id
	 *	PAYMENT		TB_PAYMENT_MST	status			payment_id
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param nextSystemId ( 다음 진행 할 상태코드 시스템 아이디 )
	 * @return etpDynamicParamsDTO ( target_table, target_status_col, target_pk_col )
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private EtpDynamicParamsDTO getTargetParams(String nextSystemId) throws Exception {
		
		EtpDynamicParamsDTO etpDynamicParamsDTO = new EtpDynamicParamsDTO();
		etpDynamicParamsDTO = bizWorkflowMapperAdm.selectTargetParams(nextSystemId);
		
		if ( etpDynamicParamsDTO == null ) {
			
			throw new Exception("유효하지 않은 시스템 코드입니다.");
		}
		
		return etpDynamicParamsDTO;
	}
	
	/**
	 * 
	 * 4. 다음 상태코드 업데이트 동적쿼리 부분입니다.
	 * 각 시스템 ID에 맞는 테이블의 상태코드를 업데이트 처리할 세팅 DTO 부분입니다.
	 * @author GD
	 * @since 2026. 2. 13.
	 * @param edDto				// 업데이트할 테이블, 업데이트할 상태코드컬럼, 조건절에서 사용할 식별자 ID컬럼
	 * @param updateEtpStatus	// 업데이트할 상태코드
	 * @param currentEtpStatus	// 현재 상태코드
	 * @param orderId			// 식별자 ( etp_doc_id, order_id, payment_id )
	 * @param nextSystemId		// 상태코드를 업데이트 할 다음 시스템 아이디
	 * @param userId			// 요청자 아이디
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 13.  GD       최초 생성
	 */
	private EtpStatusUpdateDTO getEtpStatusUpdateInfo(EtpDynamicParamsDTO edDto,
													String updateEtpStatus,
													String currentEtpStatus,
													Integer orderId,
													String nextSystemId,
													String userId) throws Exception {
		
		String targetTable = edDto.getTargetTable();					// 업데이트 대상 테이블 TB_EST_DOC
		String targetStatusCol = edDto.getTargetStatusCol();			// 업데이트 테이블 상태코드컬럼 est_status
		String targetPkCol = edDto.getTargetPkCol();					// 업데이트 테이블 식별자 est_doc_id

		BizChkParamsDTO bcdto = new BizChkParamsDTO();
		bcdto.setOrderId(orderId);
		bcdto.setUserId(userId);

		BizChkParamsDTO bcp = bizWorkflowMapperAdm.selectRefIds(bcdto);

		// 식별번호 세팅
		Integer refId = 0;

		if (nextSystemId.equals("ESTIMATE")) {
			refId = bcp.getEstId();
		} else if (nextSystemId.equals("PAYMENT")) {
			refId = bcp.getPaymentId();
		} else if (nextSystemId.equals("ORDER") || nextSystemId.equals("PURCHASE")) {
			refId = bcp.getOrderId();
		} else {
			throw new Exception("알 수 없는 식별번호 입니다.");
		}

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
	 * 5. 히스토리 이력 추가 DTO 값 설정 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param approvalDecisionRequestDTO
	 * @return histInsertDTO (히스토리이력 DTO)
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	private EtpHistInsertDTO getEtpHistInsert(ApprovalDecisionRequestDTO approvalDecisionRequestDTO) {
		
		// 무조건 히스토리 이력은 주문식별번호로 업데이트 됩니다.
		Integer refId = approvalDecisionRequestDTO.getOrderId();
		String requestEtpStatus = approvalDecisionRequestDTO.getRequestEtpStatus();
		String rejtRsn = approvalDecisionRequestDTO.getRejtRsn();
		// 승인자
		String apprUserNo = approvalDecisionRequestDTO.getApprUserNo();
		// 요청자
		String requestUserNo = approvalDecisionRequestDTO.getRequestUserNo();
		// 요청자
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
	 *
	 * 6. 상태 업데이트 및 이력 저장을 수행하는 공통 로직
	 * @param edDto				// 동적 테이블
	 * @param updateStatus		// 업데이트 상태코드
	 * @param currentStatus		// 현재 상태코드
	 * @param orderId			// 주문식별번호
	 * @param systemId			// 시스템아이디
	 * @param userId			// 요청자아이디
	 * @param requestDTO		// 클라이언트 요청 DTO
	 * @return updateResult		// 업데이트 최종 결과
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 16.  GD       최초 생성
	 */
	private int processUpdateAndLog(EtpDynamicParamsDTO edDto,
									String updateStatus, String currentStatus,
									Integer orderId, String systemId, String userId,
									ApprovalDecisionRequestDTO requestDTO) throws Exception {

		EtpStatusUpdateDTO edto = this.getEtpStatusUpdateInfo(edDto, updateStatus, currentStatus, orderId, systemId, userId);

		int updateResult = 0;

		// 1. 상태코드 업데이트 여기서 시스템ID는 다음 상태코드의 시스템ID입니다.
		if (systemId.equals("ESTIMATE") || systemId.equals("PAYMENT")) {

			// 1. 견적서 테이블 또는 결제 테이블 업데이트
			// 다음 스텝이 1차 결제 요청일때. 체크부분 중요
			// 코드리뷰가 결과 이때 결제 승인이 되어야지 TB_PAYMENT 테이블이 INSERT가 되는것으로 확인
			// 따라서 다음 스텝이 1차 결제 요청, 2차 결제 요청으로 변경이 필요한 경우 동적테이블은 업데이트 처리 안합니다.
			if ( "pm001".equals(requestDTO.getRequestEtpStatus()) || 
					"pm003".equals(requestDTO.getRequestEtpStatus()) ) {
				
				// 다음 주문테이블 업데이트가 필요해서 1 값으로 성공처리로 넘겨준다.
				updateResult = 1;
			} else {
				updateResult =  bizWorkflowMapperAdm.updateEtpStatus(edto);
			}
			
			// 2. 주문 테이블 업데이트
			if (updateResult > 0) {

				// 식별자 주문식별자로 교체
				edto.setRefId(orderId);
				// updateResult = bizWorkflowMapperAdm.updateEtpStatus(edto);
				updateResult = bizWorkflowMapperAdm.fixUpdateOrderStatus(edto);

				if (updateResult < 1) {
					throw new Exception("주문 테이블 추가 업데이트에 실패하였습니다.");
				}
			} else {
				throw new Exception("견적서 테이블 업데이트에 실패하였습니다.");
			}
		} else if (systemId.equals("ORDER") || systemId.equals("PURCHASE")) {

			// 1. 주문 테이블 업데이트
			updateResult =  bizWorkflowMapperAdm.updateEtpStatus(edto);

			if (updateResult < 1) {
				throw new Exception("주문 테이블 업데이트에 실패하였습니다.");
			}
		} else {
			throw new Exception("알 수 없는 시스템 코드입니다.");
		}

	    // 2. 이력 추가 (TB_ETP_HIST)
		updateResult = bizWorkflowMapperAdm.insertEtpHist(this.getEtpHistInsert(requestDTO));
	    
	    if (updateResult <= 0) {
	        throw new Exception("이력 추가 중 오류가 발생했습니다.");
	    }
	    
	    return updateResult;
	}
}
