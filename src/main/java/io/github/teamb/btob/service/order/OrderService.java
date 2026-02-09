package io.github.teamb.btob.service.order;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.est.EstDocDTO;
import io.github.teamb.btob.dto.order.OrderDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {
	private final OrderMapper orderMapper;
	private final CartMapper cartMapper;
	private final BizWorkflowService bizWorkflowService; // 공통 워크플로우 서비스
	private final LoginUserProvider loginUserProvider;
	
	/**
     * 1. orderSubmit: 최초 주문 생성 (PENDING -> REQ)
     * 장바구니 아이템들을 모아 하나의 주문(Master)을 생성합니다.
     */
	public void processOrderRequest(Map<String, Object> params) throws Exception {
	    
	    // 1. 로그인 유저 정보 획득
	    Integer loginUserNo = loginUserProvider.getLoginUserNo();
	    String loginUserId = loginUserProvider.getLoginUserId(); 
	    if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

	    // 2. 권한별 시스템 ID 및 초기 상태값 설정
	    String requestLevel = (String) params.get("requestLevel");
	    String systemId = "USER_REQ".equals(requestLevel) ? "ORDER" : "PURCHASE";
	    String nextStatus = "USER_REQ".equals(requestLevel) ? "od001" : "pr001";

	    // 3. 주문번호(orderNo) 생성 (규칙: ORDER-회사코드-날짜-순번)
	    String orderNo = orderMapper.selectFormattedOrderNo("ORDER", loginUserId);

	    // 4. TB_ORDER_MST - 데이터 저장 (OrderDTO 활용)
	    OrderDTO orderDto = OrderDTO.builder()
	            .orderNo(orderNo)
	            .userNo(loginUserNo)    // DTO의 userId 필드(int)에 숫자 PK 세팅
	            .orderStatus(nextStatus)
	            .regId(loginUserId)    // 등록자 아이디(String)
	            .useYn("Y")
	            .build();

	    // upsertOrderMaster 실행 후 orderDto.getOrderId()에 PK가 자동으로 채워짐
	    orderMapper.upsertOrderMaster(orderDto);
	    int generatedOrderId = orderDto.getOrderId(); 

	    // 5. 공통 워크플로우(BizWorkflowService) 호출
	    ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
	    approvalDTO.setSystemId(systemId);      // "ORDER" 또는 "PURCHASE"
	    approvalDTO.setRefId(generatedOrderId); // 방금 생성된 PK(order_id)
	    approvalDTO.setApprovalStatus("APPROVED");
	    approvalDTO.setRequestEtpStatus(nextStatus);
	    approvalDTO.setApprUserNo(loginUserNo);
	    approvalDTO.setRequestUserNo(loginUserNo);

	    // 공통 서비스 호출: 상태 업데이트 및 이력 로그 동시 처리
	    bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);

	    // 6. TB_CART - 장바구니 항목 업데이트
	    updateCartItems((String) params.get("cartIds"), orderNo, loginUserId);
	        
	    }
	
	/**
     * 2. EstSubmit: 최초 견적 생성 (PENDING -> REQ)
     * 장바구니 아이템들을 모아 하나의 주문(Master)을 생성합니다.
	 * @throws Exception 
     */
	public void processEstRequest(Map<String, Object> params) throws Exception {
		Integer loginUserNo = loginUserProvider.getLoginUserNo();
	    String loginUserId = loginUserProvider.getLoginUserId();
	    if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

	    // 2. 견적 전용 설정
	    String systemId = "ESTIMATE"; 
	    String nextStatus = "et002"; // 
	    
	    String estNo = orderMapper.selectFormattedEstNo(systemId, loginUserId);
	    
	    EstDocDTO docDto = EstDocDTO.builder()
	            .estNo(estNo)
	            .companyName((String) params.get("companyName"))
	            .companyPhone((String) params.get("companyPhone"))
	            .requestUserId(loginUserNo)
	            .ctrtNm((String) params.get("ctrtNm"))
	            .baseTotalAmount(params.get("totalSum") instanceof Number ? ((Number)params.get("totalSum")).intValue() : 0)
	            .targetTotalAmount(Integer.parseInt(String.valueOf(params.get("targetTotalAmount"))))
	            .estdtMemo((String) params.get("estdtMemo"))
	            .regId(loginUserNo)
	            .build();
	    
	    orderMapper.insertEstDoc(docDto);
	    
	    String orderNo = orderMapper.selectFormattedOrderNo("ORDER", loginUserId);
	    Integer generatedQuoteReqId = docDto.getEstDocId();
	    
	    OrderDTO orderDto = OrderDTO.builder()
	            .orderNo(orderNo)
	            .quoteReqId(generatedQuoteReqId)
	            .userNo(loginUserNo)    // DTO의 userId 필드(int)에 숫자 PK 세팅
	            .orderStatus(nextStatus)
	            .regId(loginUserId)    // 등록자 아이디(String)
	            .useYn("Y")
	            .build();
	    
	    orderMapper.upsertOrderMaster(orderDto);
	   	
	    int generatedOrderId = orderDto.getOrderId(); 

	    // 5. 공통 워크플로우(BizWorkflowService) 호출
	    ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
	    approvalDTO.setSystemId(systemId);      // "ORDER" 또는 "PURCHASE"
	    approvalDTO.setRefId(generatedOrderId); // 방금 생성된 PK(order_id)
	    approvalDTO.setApprovalStatus("APPROVED");
	    approvalDTO.setRequestEtpStatus(nextStatus);
	    approvalDTO.setApprUserNo(loginUserNo);
	    approvalDTO.setRequestUserNo(loginUserNo);

	    // 공통 서비스 호출: 상태 업데이트 및 이력 로그 동시 처리
	    bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);

	    // 6. TB_CART - 장바구니 항목 업데이트
	    updateCartItems((String) params.get("cartIds"), orderNo, loginUserId);
	    }
	

	/**
     * 3. modifyStatus: 단계별 상태 업데이트 (REQ 내 단계 이동)
     * 이미 존재하는 주문의 상태 코드만 변경합니다.
     */
    public void modifyOrderStatus(Map<String, Object> params) throws Exception {
    	// 1. 유저 정보 체크
        Integer loginUserNo = loginUserProvider.getLoginUserNo();
        String loginUserId = loginUserProvider.getLoginUserId();
        if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

        // 2. JS에서 넘어온 문자열 주문번호(orderNo) 꺼내기
        String orderNo = (String) params.get("refId"); // JS에서 { refId: orderNo } 로 보냈음
        String systemId = (String) params.get("systemId");
        String approvalStatus = (String) params.get("approvalStatus");
        String requestEtpStatus = (String) params.get("requestEtpStatus");
        
        // 필수 파라미터 누락 방지 (방어 코드)
        if (orderNo == null || systemId == null) {
            throw new Exception("필수 요청 정보가 누락되었습니다.");
        }
        
        // 3. [핵심] 주문번호(No)를 이용해 테이블에서 숫자 PK(ID) 조회
        // selectOrderIdByNo 같은 쿼리가 필요합니다.
        Integer generatedOrderId = orderMapper.getOrderIdByOrderNo(orderNo);
        
        if (generatedOrderId == null) {
            throw new Exception("존재하지 않는 주문 번호입니다: " + orderNo);
        }

        // 4. 공통 워크플로우 DTO 세팅 (ID 기반)
        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId); // 이제 숫자로 된 PK가 들어감!
        approvalDTO.setApprovalStatus(approvalStatus);
        approvalDTO.setRequestEtpStatus(requestEtpStatus);
        approvalDTO.setApprUserNo(loginUserNo);
        approvalDTO.setRequestUserNo(loginUserNo);

        // 5. 공통 서비스 호출
        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
       
    }
    
    // 카트 상태 변경 공통
    private void updateCartItems(String cartIdsStr, String orderNo, String loginUserId) {
        if (cartIdsStr != null && !cartIdsStr.isEmpty() && !"undefined".equals(cartIdsStr)) {
            List<String> idList = Arrays.stream(cartIdsStr.split(","))
                    .map(String::trim)
                    .filter(id -> !id.isEmpty())
                    .collect(Collectors.toList());
            
            if (!idList.isEmpty()) {
                Map<String, Object> cartParams = new HashMap<>();
                cartParams.put("orderNo", orderNo);
                cartParams.put("idList", idList);
                cartParams.put("userId", loginUserId);
                cartParams.put("status", "REQ");
                cartMapper.updateCartOrderInfo(cartParams);
            }
        }
    }
}