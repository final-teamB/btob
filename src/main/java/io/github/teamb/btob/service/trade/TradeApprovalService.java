package io.github.teamb.btob.service.trade;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.document.DocumentInsertDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
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
	    //Object requestUserNoObj = params.get("userNo");
	    //if (requestUserNoObj != null) {
	    requestDto.setRequestUserNo(receiverId);
	    //}

	    // 3. 공통 워크플로우 서비스 호출 (자동으로 TB_ORDER_MST 업데이트 + 이력 생성)
	    bizWorkflowServiceImpl.modifyEtpStatusAndLogHist(requestDto);
	    
	    if ("od002".equals(status)) {
	        try {
	            // 1. 문서 번호 생성 (PO-회사코드-날짜-순번)
	            String docNo = tradeDocMapper.selectFormattedDocNo("PO", receiverId);
	            
	            // 2. DTO 객체 생성 및 데이터 빌드
	            DocumentInsertDTO docDto = new DocumentInsertDTO();
	            
	            docDto.setDocNo(docNo);
	            docDto.setDocType("PURCHASE_ORDER");
	            
	            // [선택하신 제목 형식] [주문번호] 물품 공급 발주서
	            String orderNo = (String) params.get("orderNo");
	            docDto.setDocTitle("[" + orderNo + "] 물품 공급 발주서");
	            
	            docDto.setOrderId(Integer.parseInt(orderIdObj.toString()));
	            docDto.setOwnerUserId(receiverId); // 문서를 조회할 권한을 가진 유저(발주자)
	            
	            // [금액 정보] 1차 결제 총액 (혹은 1차+2차 합계)
	            if (params.get("totalSum") != null) {
	                // 숫자 형식이 확실치 않을 수 있으므로 안전하게 처리
	                int totalSum = Integer.parseInt(params.get("totalSum").toString());
	                docDto.setTotalAmt(totalSum);
	            }
	            
	            docDto.setRegId(loginUserId);
	            
	            // 3. Mapper 호출 (TB_DOCUMENT_MST에 최종 인서트)
	            tradeDocMapper.insertDocument(docDto);
	            
	            System.out.println("발주서 생성 완료: " + docNo);
	            
	        } catch (Exception e) {
	            // 예외 로그 남기기 (필요 시 RuntimeException으로 던져 트랜잭션 롤백)
	            System.err.println("발주서(PO) 자동 생성 중 오류 발생: " + e.getMessage());
	            e.printStackTrace();
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
	
	
}
