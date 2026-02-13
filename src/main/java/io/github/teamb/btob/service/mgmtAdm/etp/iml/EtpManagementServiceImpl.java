package io.github.teamb.btob.service.mgmtAdm.etp.iml;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.etp.EtpApprovRejctRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;
import io.github.teamb.btob.mapper.bizworkflow.BizWorkflowMapperAdm;
import io.github.teamb.btob.mapper.mgmtAdm.EtpMgmtAdmMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowServiceAdm;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.etp.EtpManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
@RequiredArgsConstructor
public class EtpManagementServiceImpl implements EtpManagementService {
	
	private final EtpMgmtAdmMapper etpMgmtAdmMapper;
	private final BizWorkflowMapperAdm bizWorkflowMapperAdm;
	private final CommonService commonService;
	private final BizWorkflowServiceAdm bizWorkflowServiceAdm;

	/**
	 * 
	 * 견적/주문/구매/결제 검색 조회 및 조회 건수
	 * @author GD
	 * @since 2026. 2. 12.
	 * @param searchParams
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 12.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchEtpListDTO> getSearchConditionEtpList(Map<String, Object> searchParams)
			throws Exception {
				
				// 파라미터 검증
				/* 조회 빈값이면 오류 떠서 주석처리
				 * if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
				 * 
				 * throw new Exception("유효 하지 않은 파라미터 입니다."); }
				 */
		
				// LIMIT 절 에러 방지를 위해 String으로 넘어온 숫자를 Integer로 명시적 형변환
			    if (searchParams.get("startRow") != null) {
			        int startRow = Integer.parseInt(String.valueOf(searchParams.get("startRow")));
			        searchParams.put("startRow", startRow);
			    }
			    
			    if (searchParams.get("limit") != null) {
			        int limit = Integer.parseInt(String.valueOf(searchParams.get("limit")));
			        searchParams.put("limit", limit);
			    }
				
				// 1. 전체 건수 조회 (검색 조건 유지)
			    Integer totalCnt = etpMgmtAdmMapper.selectEtpSearchConditioinListCntAdm(searchParams);

			    // 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
			    List<SearchEtpListDTO> etpList = Collections.emptyList();
			    
			    if (totalCnt > 0) {
			    	
			    	etpList = etpMgmtAdmMapper.selectEtpSearchConditioinListAdm(searchParams);
			        
			    }

			    // 3. 통합 객체로 반환
			    return new PagingResponseDTO<>(etpList, totalCnt);
	}

	/**
	 * 
	 * 관리자쪽 견적 승인/반려 , 구매 승인/반려 처리 버튼
	 * @author GD
	 * @since 2026. 2. 12.
	 * @param etpApprovRejctRequestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 12.  GD       최초 생성
	 */
	@Override
	public Integer handleApprovalRejctButton(EtpApprovRejctRequestDTO etpApprovRejctRequestDTO) throws Exception {
		
		// 파라미터 검증
		if ( !(commonService.nullEmptyChkValidate(etpApprovRejctRequestDTO)) ) {

			throw new Exception("유효 하지 않은 파라미터 입니다."); 
		}
		
		Integer refId;
		
		String approvalStatus = etpApprovRejctRequestDTO.getApprovalStatus(); // 승인,반려 타입 , APPROVED, REJECTED, COMPLETE
		// 견적요청
		String systemId = etpApprovRejctRequestDTO.getSystemId();
		String userId = etpApprovRejctRequestDTO.getUserId();	// 요청자입니다.
		String userType = etpApprovRejctRequestDTO.getUserType(); // 요청자 직급
		Integer estId = etpApprovRejctRequestDTO.getEstId();	// 견적식별
		Integer ordId = etpApprovRejctRequestDTO.getOrderId(); // 주문식별
		
		if ("ESTIMATE".equals(systemId)) {
	        refId = estId; // 견적일 때는 est_id 사용
	    } else {
	        refId = ordId; // 주문/구매일 때는 order_id 사용
	    }

	    if (refId == null || refId == 0) {
	        throw new Exception("유효한 식별번호(ID)가 존재하지 않습니다.");
	    }
		
		
		//관리자가 처리할 수 있는 단계인지 시스템단계체크부터
		List<SearchEtpListDTO> systemIdChk = etpMgmtAdmMapper.approvRejctChgAuthByAdm();
		List<String> validSystemIds = systemIdChk.stream()
			    .map(SearchEtpListDTO::getSystemId)
			    .collect(Collectors.toList());

		boolean isValidSystemId = validSystemIds.contains(systemId);
		
		if (!isValidSystemId) {
		    throw new IllegalArgumentException("관리자가 처리할 수 없는 시스템단계입니다.");
		}
		
		// 3. BizWorkflow 처리를 위한 DTO 변환 및 데이터 보정
		// 승인이든 반려든 공통으로 필수로 들어옵니다
	    ApprovalDecisionRequestDTO decisionDto = new ApprovalDecisionRequestDTO();
	    // 조회할때 식별자 검색을 ORDER 테이블 값으로 밖에 할 수 가 없다..
	    decisionDto.setSystemId(systemId);
	    decisionDto.setRefId(refId);						// 동적 테이블 업데이트때 찾기 위한 식별 번호
	    decisionDto.setRequestUserNo(userId);				// 요청자입니다
	    decisionDto.setApprovalStatus(approvalStatus);
	    decisionDto.setOrderId(ordId);						// 고정으로 상태코드를 변경해줘야함 히스토리 업데이트에도 사용할 것
	    
	    // [중요] 현재 상태를 먼저 조회해와야 다음 상태를 찾을 수 있음
	    String currentStatus = bizWorkflowServiceAdm.selectCurrentEtpStatusValidate(refId, userId);
	    
	    // 여기서 안바꿔주면 히스토리 이력이나 다른 타 테이블 동적으로 상태값 수정 못해준다.
	    
	    
	    String targetNextStatus = "";
	    
	    // --- [분기 처리 시작] ---
	    if ("APPROVED".equals(approvalStatus)) {
	        // 승인 로직: 사유 입력 필요 없음
	        targetNextStatus = bizWorkflowMapperAdm.selectNextStatus(currentStatus);
	        decisionDto.setRejtRsn(""); // 승인은 공백 처리
	        
	    } else if ("REJECTED".equals(approvalStatus)) {
	        // 반려 로직: 사유 검증 및 세팅
	        if (etpApprovRejctRequestDTO.getRejtRsn() == null || etpApprovRejctRequestDTO.getRejtRsn().trim().isEmpty()) {
	            throw new Exception("반려 시에는 반드시 반려 사유를 입력해야 합니다.");
	        }
	        
	        targetNextStatus = bizWorkflowMapperAdm.selectRejtStatus(currentStatus);
	        decisionDto.setRejtRsn(etpApprovRejctRequestDTO.getRejtRsn()); // 반려 사유 세팅
	    }
	    // --- [분기 처리 종료] ---

	    if (targetNextStatus == null || targetNextStatus.isEmpty()) {
	    	
	        throw new Exception("현재 상태(" + currentStatus + ")에서 변경 가능한 다음 상태 코드가 존재하지 않습니다.");
	    }

	    // 4. BizWorkflow 로직에 세팅
	    decisionDto.setRequestEtpStatus(targetNextStatus);
	    
	    // 관리자 세션 정보 통해서 해당 사번/식별번호를 넣어주세요 승인자 넣어주는 곳.
	    // 차후에 loginUserId로 넣을거임
	    decisionDto.setApprUserNo("admin@gmail.com"); //  승인자
	    decisionDto.setUserId("admin@gmail.com");	// 로그인사용자 ( 지금여긴 관리자 페이지라 승인자와 동일함)

	    // 5. 공통 로직 호출
	    Integer result = bizWorkflowServiceAdm.modifyEtpStatusAndLogHist(decisionDto);
	    
	    // 5.1 만약 타겟이 구매요청으로 들어온거면 승인하면 구매승인 후 
	    // 바로 다음단계인 1차결제요청으로 가야하므로 빅스탭이 필요함
	    // pr002로 다시 세팅한 후 다시 한번 돌려준다.
	    if ( result > 0 ) {
		    if ( targetNextStatus.equals("pr002") ) {
		    	
		    	// [중요] 다음 단계를 다시 조회해야 함 (pr002의 다음 단계 코드 조회)
	            String secondTargetStatus = bizWorkflowMapperAdm.selectNextStatus("pr002"); 
	            
	            if (secondTargetStatus != null && !secondTargetStatus.isEmpty()) {

	            	decisionDto.setRequestEtpStatus(secondTargetStatus);
	                // 2차 자동 승인 처리 (예: 결제요청 단계로 진입)
	                result = bizWorkflowServiceAdm.modifyEtpStatusAndLogHist(decisionDto);
	            }
		    }
	    } else {
	    	
	    	throw new Exception("상태 변경 및 히스토리 등록 시 오류 발생");
	    }
	    
	    // 5.2 만약 요청자가 MASTER이고 견적요청으로 들어온거면 승인하면 견적승인 후
	    // 바로다음 단계인 주문요청으로 가야하고
	    // 그 바로다음 단계인 주문요청승인으로 가는 자이언트스탭이 필요하다
	    // et003 을 한번 세팅해서 다시 돌려주고
	    // od001 을 한번 다시 세팅해서 돌려준다
	    if ( userType.equals("MASTER") && result > 0 ) {
	    	
	    	if ( targetNextStatus.equals("et003") ) {
		    	
		    	// [중요] 다음 단계를 다시 조회해야 함 (et003의 다음 단계 코드 조회)
	            String secondTargetStatus = bizWorkflowMapperAdm.selectNextStatus("et003"); 
	            
	            if (secondTargetStatus != null && !secondTargetStatus.isEmpty()) {

	            	decisionDto.setRequestEtpStatus(secondTargetStatus);
	                // 2차 자동 승인 처리 (예: 주문요청 단계로 진입)
	                result = bizWorkflowServiceAdm.modifyEtpStatusAndLogHist(decisionDto);
	                
	                if ( result > 0) {
	                	
	                	if ( secondTargetStatus.equals("od001") ) {
	                		
	                		// [중요] 다음 단계를 다시 조회해야 함 (od001의 다음 단계 코드 조회)
	        	            String thirdTargetStatus = bizWorkflowMapperAdm.selectNextStatus("od001");
	        	            
	        	            if (thirdTargetStatus != null && !thirdTargetStatus.isEmpty()) {
	        	            	
	        	            	decisionDto.setRequestEtpStatus(thirdTargetStatus);
	        	            	// 3차 자동 승인 처리 (예: 주문승인 단계로 진입)
	        	            	result = bizWorkflowServiceAdm.modifyEtpStatusAndLogHist(decisionDto);
	        	            }
	                	}
	                }
	            }
		    }
	    }
		
		return result;
	}

	/**
	 * 
	 * 셀렉박스 리스트 추출
	 * @author GD
	 * @since 2026. 2. 12.
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 12.  GD       최초 생성
	 */
	@Override
	public Map<String, List<SelectBoxVO>> getEtpFilterSelectBoxList() {

		Map<String, List<SelectBoxVO>> resultMap = new HashMap<>();

	    // 1. 진행상태코드
	    resultMap.put("etpSttsCdList", getSelectBox("TB_ETP_STTS_CD", "etp_stts_cd", "etp_stts_nm", "", ""));

	    // 2. 주문테이블 등록 연도별
	    resultMap.put("ordYearList", getSelectBox("TB_ORDER_MST", 
	    							"DISTINCT(YEAR(order_date))", 
	    							"CONCAT(YEAR(order_date), '년')", 
	    							"YEAR(order_date)", 
	    							""));

	    return resultMap;
	}
	
	/**
	 * 
	 * 셀렉박스 파라미터 세팅을 위한 내부 헬퍼 메서드 (리턴타입 VO로 수정)
	 * @author GD
	 * @since 2026. 2. 12.
	 * @param table 타겟테이블
	 * @param cd 타겟코드컬럼
	 * @param nm 타겟코드컬럼명칭
	 * @param target where 조건절에 들어갈 컬럼명
	 * @param where where 조건값
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 6.  GD       최초 생성
	 */
	private List<SelectBoxVO> getSelectBox(String table, String cd, String nm, String target, String where) {
	    
	    SelectBoxListDTO dto = new SelectBoxListDTO();
	    dto.setCommonTable(table);
	    dto.setCommNo(cd);
	    dto.setCommName(nm);
	    dto.setTargetCols(target);
	    dto.setWhereCols(where);
	    
	    // 이제 Generic 파라미터(class)를 넘길 필요 없이 깔끔하게 호출 가능합니다.
	    return commonService.getSelectBoxList(dto);
	}
}
