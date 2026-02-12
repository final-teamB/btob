package io.github.teamb.btob.service.trade;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.mapper.trade.TradeApprovalMapper;
import io.github.teamb.btob.service.BizWorkflow.impl.BizWorkflowServiceImpl;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class TradeApprovalService {
	private final TradeApprovalMapper tradeApprovalmapper;
	private final OrderMapper orderMapper;
	private final BizWorkflowServiceImpl bizWorkflowServiceImpl;
	private final LoginUserProvider loginUserProvider;

		
	public List<TradePendingDTO> getTradePendingList(TradePendingDTO dto) {
		dto.setUserNo(loginUserProvider.getLoginUserNo());
		return tradeApprovalmapper.getTradePendingList(dto);
	}

	public void updateOrderStatus(Map<String, Object> params) throws Exception {
	    // 1. 세션 정보 가져오기
	    Integer loginUserNo = loginUserProvider.getLoginUserNo();
	    String loginUserId = loginUserProvider.getLoginUserId(); 
	    if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");
	   
	    // 2. BizWorkflow 호출을 위한 DTO 세팅
	    ApprovalDecisionRequestDTO requestDto = new ApprovalDecisionRequestDTO();
	    
	    // 이미지 기반 설정 값
	    requestDto.setSystemId("ORDER"); // TB_ETP_TARGET_TABLE의 system_id와 매칭
	    
	    // 팝업에서 넘어온 PK (order_id) - String일 경우 Integer로 변환
	    Object orderIdObj = params.get("orderId");
	    if (orderIdObj == null) throw new Exception("식별 번호(ID)가 누락되었습니다.");
	    requestDto.setRefId(Integer.parseInt(orderIdObj.toString()));
	    String rejectReason = (String) params.get("rejectReason");
	    
	    // 승인(od002) / 반려(od999) 판단
	    String status = (String) params.get("status");
	    requestDto.setApprovalStatus("od002".equals(status) ? "APPROVED" : "REJECTED");
	    requestDto.setRequestEtpStatus(status); 
	    requestDto.setRejtRsn(rejectReason);
	    
	    // 사용자 정보 세팅
	    requestDto.setApprUserNo(loginUserId); // 승인권자 번호
	    requestDto.setUserId((String) params.get("userId"));
	    
	    // 원 요청자 번호 (JSP/그리드에서 userNo로 넘겨준 값)
	    // Object requestUserNoObj = params.get("userNo");
	    //if (requestUserNoObj != null) {
	        //requestDto.setRequestUserNo(Integer.parseInt(requestUserNoObj.toString()));
	    	requestDto.setRequestUserNo(loginUserId);
	    //}

	    // 3. 공통 워크플로우 서비스 호출 (자동으로 TB_ORDER_MST 업데이트 + 이력 생성)
	    bizWorkflowServiceImpl.modifyEtpStatusAndLogHist(requestDto);
	}
	
	
}
