package io.github.teamb.btob.service.mgmtAdm.etp.iml;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionResultDTO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.etp.EtpApprovRejctRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;
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

		String currentSystemId = etpApprovRejctRequestDTO.getSystemId();		// 현재 시스템 ID
		Integer ordId = etpApprovRejctRequestDTO.getOrderId(); 				  	// 주문식별자
		String approvalStatus = etpApprovRejctRequestDTO.getApprovalStatus(); 	// 승인,반려 타입 , APPROVED, REJECTED, COMPLETE
		String userId = etpApprovRejctRequestDTO.getUserId();				  	// 요청자
		String rejtRsn = etpApprovRejctRequestDTO.getRejtRsn() != null			// 반려 시 반려 사유
				? etpApprovRejctRequestDTO.getRejtRsn()
				: "";

		// currentSystemId, orderId, approvalStatus, userId, requestUserNo
		// 진행코드의 현재 시스템ID, 주문식별자, 요청타입, 요청자, 요청자
		// 승인자는 공통모듈에서 확인처리합니다.
		ApprovalDecisionRequestDTO approvalDecisionRequestDTO = new ApprovalDecisionRequestDTO();
		approvalDecisionRequestDTO.setSystemId(currentSystemId);
		approvalDecisionRequestDTO.setOrderId(ordId);
		approvalDecisionRequestDTO.setApprovalStatus(approvalStatus);
		approvalDecisionRequestDTO.setUserId(userId);
		approvalDecisionRequestDTO.setRequestUserNo(userId);
		approvalDecisionRequestDTO.setRejtRsn(rejtRsn);
		
		System.out.println("ETPMANAGEMNET 관리자 주문서비스 현재 시스템 아이디 : " + currentSystemId);
		System.out.println("ETPMANAGEMNET 현재 주문 식별자 : " + ordId);
		
		SearchEtpListDTO param = etpMgmtAdmMapper.selectEtpParamsChk(ordId);
		String paramOrderStatus = param.getOrderStatus();
		System.out.println("ETPMANAGEMNET 현재 주문 상태코드 : " + paramOrderStatus);
		String paramUserType = param.getUserType();
		System.out.println("ETPMANAGEMNET 해당 주문 요청자의 권한 상태 : " + paramUserType);
		int result = 1;

		// 단건 고정
		int loopCnt = 1;

		// 연속 승인 처리가 필요할때
		// 견적요청을 마스터 직급 사용자가 했을 경우
		// 견적요청(현재상태) -> 견적승인 -> 주문요청 -> 주문승인
		if ( approvalStatus.equals("APPROVED") &&
				paramUserType.equals("MASTER") &&
				paramOrderStatus.equals("et002") ) {
			loopCnt = 3;
			System.out.println("요청한 사람이 마스터 이고 현재 견적요청상태이면 여기 탑니다.");
		// 구매요청(현재상태) -> 구매승인 -> 1차결제요청
		} else if ( approvalStatus.equals("APPROVED") && paramOrderStatus.equals("pr001") ) {
			loopCnt = 2;
			System.out.println("요청한 사람이 마스터 이고 현재 구매요청상태이면 여기 탑니다.");
		}

		ApprovalDecisionResultDTO resultDto = null;

		for (int i = 0; i < loopCnt; i++) {
			resultDto = modifyAndUpdateSystemId(approvalDecisionRequestDTO);
			System.out.println("루프 몇 번 도는지 확인 합니다. : " + i + " 번");
		}

		return result;
	}

	
	/**
	 * 연속 승인 처리 시 사용
	 * @param approvalDecisionRequestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 16.  GD       최초 생성
	 */
	private ApprovalDecisionResultDTO modifyAndUpdateSystemId(
			ApprovalDecisionRequestDTO approvalDecisionRequestDTO) throws Exception {

		ApprovalDecisionResultDTO resultDto =
				bizWorkflowServiceAdm.modifyEtpStatusAndLogHist(approvalDecisionRequestDTO);

		if (!commonService.nullEmptyChkValidate(resultDto)) {
			throw new Exception("관리자가 진행 상태 변경 작업 도중 오류가 발생했습니다.");
		}

		approvalDecisionRequestDTO.setSystemId(resultDto.getSystemId());

		return resultDto;
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
