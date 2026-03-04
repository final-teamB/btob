package io.github.teamb.btob.service.trade;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.document.DocumentInsertDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.document.TradeDocMapper;
import io.github.teamb.btob.mapper.trade.TradeApprovalMapper;
import io.github.teamb.btob.service.BizWorkflow.impl.BizWorkflowServiceImpl;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class TradeApprovalService {
	private final TradeApprovalMapper tradeApprovalmapper;
	private final BizWorkflowServiceImpl bizWorkflowServiceImpl;
	private final LoginUserProvider loginUserProvider;
	private final NotificationService notificationService;
	private final CartMapper cartMapper;
	private final TradeDocMapper tradeDocMapper;

		
	public List<TradePendingDTO> getTradePendingList(TradePendingDTO dto) {
		dto.setUserNo(loginUserProvider.getLoginUserNo());
		return tradeApprovalmapper.getTradePendingList(dto);
	}

	public void updateOrderStatus(Map<String, Object> params) throws Exception {
	    // 1. 세션 정보 가져오기
	    Integer loginUserNo = loginUserProvider.getLoginUserNo();
	    String loginUserId = loginUserProvider.getLoginUserId(); 
	    String receiverId = (String) params.get("userId");
	    if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");
	   
	    // 2. BizWorkflow 호출을 위한 DTO 세팅
	    ApprovalDecisionRequestDTO requestDto = new ApprovalDecisionRequestDTO();
	    
	    // 이미지 기반 설정 값
	    requestDto.setSystemId("ORDER"); // TB_ETP_TARGET_TABLE의 system_id와 매칭
	    
	    // 팝업에서 넘어온 PK (order_id) - String일 경우 Integer로 변환
	    Object orderIdObj = params.get("orderId");
	    if (orderIdObj == null) throw new Exception("식별 번호(ID)가 누락되었습니다.");
	    int orderId = Integer.parseInt(orderIdObj.toString());
	    requestDto.setRefId(orderId);
	    String rejectReason = (String) params.get("rejectReason");
	    
	    // 승인(od002) / 반려(od999) 판단
	    String status = (String) params.get("status");
	    String approvalStatus = "od002".equals(status) ? "APPROVED" : "REJECTED"; // 승인/반려 결정
	    requestDto.setApprovalStatus(approvalStatus);
	    requestDto.setRequestEtpStatus(status); 
	    requestDto.setRejtRsn(rejectReason);
	    
	    // 사용자 정보 세팅
	    requestDto.setApprUserNo(loginUserId); // 승인권자 번호
	    requestDto.setUserId((String) params.get("userId"));
	    
	    // 원 요청자 번호 (JSP/그리드에서 userNo로 넘겨준 값)
	    //Object requestUserNoObj = params.get("userNo");
	    //if (requestUserNoObj != null) {
	    requestDto.setRequestUserNo(receiverId);
	    //}

	    // 3. 공통 워크플로우 서비스 호출 (자동으로 TB_ORDER_MST 업데이트 + 이력 생성)
	    bizWorkflowServiceImpl.modifyEtpStatusAndLogHist(requestDto);
	    	    
	    if ("APPROVED".equals(approvalStatus)) {
	        // --- 승인 시: 발주서(PO) 생성 로직 (기존 유지) ---
	        try {
	            Integer estId = tradeApprovalmapper.getEstIdByOrderId(orderId); 
	            boolean isFromEstimate = (estId != null && estId > 0);

	            if (!isFromEstimate) {
	                String docNo = tradeDocMapper.selectFormattedDocNo("PO", receiverId);
	                DocumentInsertDTO docDto = new DocumentInsertDTO();
	                docDto.setDocNo(docNo);
	                docDto.setDocType("PURCHASE_ORDER");
	                String orderNo = (String) params.get("orderNo");
	                docDto.setDocTitle("[" + orderNo + "] 물품 공급 발주서");
	                docDto.setOrderId(orderId);
	                docDto.setOwnerUserId(receiverId); 
	                docDto.setRegId(loginUserId);
	                
	                tradeDocMapper.insertDocument(docDto);
	            }
	        } catch (Exception e) {
	            System.err.println("발주서(PO) 생성 중 오류 발생: " + e.getMessage());
	        }
	    } else if ("REJECTED".equals(approvalStatus)) {
	        // --- 반려 시: 장바구니 상태 복구 및 문서 무효화 로직 ---
	        try {
	            String orderNo = (String) params.get("orderNo");
	            if (orderNo != null) {
	                // 1. 장바구니 상태를 PENDING으로 변경 (사용자가 수정 가능하도록)
	                // 앞서 CartMapper 인터페이스와 XML의 오타(oder_no -> order_no)를 수정하셨는지 확인해주세요!	            
	                cartMapper.updateCartStatusPending(orderNo, loginUserId);
	                
	                // 2. (선택사항) 기존에 생성된 문서가 있다면 사용불가(N) 처리
	                tradeDocMapper.updateDocUseYnByOrderId(orderId, "N", loginUserId);
	                
	                System.out.println("주문 반려 - 장바구니 상태 복구 완료: " + orderNo);
	            }
	        } catch (Exception e) {
	            System.err.println("반려 처리 중 장바구니 복구 오류: " + e.getMessage());
	        }
	    }
	    
	    // 4. 알림 발송
	    if (receiverId != null) {
	        String message = "od002".equals(status) ? "주문이 승인되었습니다." : "주문이 반려되었습니다.";
	        
	        notificationService.send(
	            receiverId, 
	            "APPROVAL", 
	            Integer.parseInt(params.get("orderId").toString()), 
	            message, 
	            loginUserId
	        );
	    }
	}

	public int selectPendingCount(String userId) {
		return tradeApprovalmapper.selectPendingCount(userId);
	}
	
	
}
