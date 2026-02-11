package io.github.teamb.btob.service.order;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.bizworkflow.ApprovalDecisionRequestDTO;
import io.github.teamb.btob.dto.est.EstDocListDTO;
import io.github.teamb.btob.dto.order.OrderDTO;
import io.github.teamb.btob.dto.order.OrderHistoryDTO;
import io.github.teamb.btob.dto.order.OrderVoDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.mapper.payment.PaymentMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {
    private final OrderMapper orderMapper;
    private final CartMapper cartMapper;
    private final PaymentMapper paymentMapper;
    private final BizWorkflowService bizWorkflowService; 
    private final LoginUserProvider loginUserProvider;
    
    public OrderVoDTO getFullOrderDetail(int orderId) {
        return orderMapper.getOrderDetailWithAll(orderId);
    }
    
    public List<OrderHistoryDTO> selectUserOrderList(OrderHistoryDTO dto, String userType) {
        return orderMapper.selectUserOrderList(dto, userType);
    }
    
    public void processOrderRequest(Map<String, Object> params) throws Exception {
        Integer loginUserNo = loginUserProvider.getLoginUserNo();
        String loginUserId = loginUserProvider.getLoginUserId(); 
        if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

        String requestLevel = (String) params.get("requestLevel");
        String systemId = "USER_REQ".equals(requestLevel) ? "ORDER" : "PURCHASE";
        String nextStatus = "USER_REQ".equals(requestLevel) ? "od001" : "pr001";

        String orderNo = orderMapper.selectFormattedOrderNo("ORDER", loginUserId);

        OrderDTO orderDto = OrderDTO.builder()
                .orderNo(orderNo)
                .userNo(loginUserNo)
                .orderStatus(nextStatus)
                .regId(loginUserId)
                .useYn("Y")
                .build();

        orderMapper.upsertOrderMaster(orderDto);
        int generatedOrderId = orderDto.getOrderId(); 

        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus("COMPLETE");
        approvalDTO.setRequestEtpStatus(nextStatus);
        approvalDTO.setApprUserNo(loginUserNo);
        approvalDTO.setRequestUserNo(loginUserNo);
        approvalDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
        updateCartItems(params.get("cartIds"), orderNo, loginUserId);
    }
    
    public void processEstRequest(Map<String, Object> params) throws Exception {
        Integer loginUserNo = loginUserProvider.getLoginUserNo();
        String loginUserId = loginUserProvider.getLoginUserId();
        if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

        String systemId = "ESTIMATE"; 
        String nextStatus = "et002"; 
        
        String estNo = orderMapper.selectFormattedEstNo(systemId, loginUserId);
        
        EstDocListDTO docDto = EstDocListDTO.builder()
                .estNo(estNo)
                .companyName((String) params.get("companyName"))
                .companyPhone((String) params.get("companyPhone"))
                .requestUserId(loginUserNo)
                .ctrtNm((String) params.get("ctrtNm"))
                .baseTotalAmount(Integer.parseInt(String.valueOf(params.get("totalSum"))))
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
                .userNo(loginUserNo)
                .orderStatus(nextStatus)
                .regId(loginUserId)
                .useYn("Y")
                .build();
        
        orderMapper.upsertOrderMaster(orderDto);
        int generatedOrderId = orderDto.getOrderId(); 

        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus("COMPLETE");
        approvalDTO.setRequestEtpStatus(nextStatus);
        approvalDTO.setApprUserNo(loginUserNo);
        approvalDTO.setRequestUserNo(loginUserNo);
        approvalDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
        updateCartItems(params.get("cartIds"), orderNo, loginUserId);
    }

    public void modifyOrderStatus(Map<String, Object> params) throws Exception {
        Integer loginUserNo = loginUserProvider.getLoginUserNo();
        String loginUserId = loginUserProvider.getLoginUserId();
        if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

        String orderNo = (String) params.get("refId");
        String systemId = (String) params.get("systemId");
        String approvalStatus = (String) params.get("approvalStatus");
        String requestEtpStatus = (String) params.get("requestEtpStatus");
        
        if (orderNo == null || systemId == null) {
            throw new Exception("필수 요청 정보가 누락되었습니다.");
        }
        
        Integer generatedOrderId = orderMapper.getOrderIdByOrderNo(orderNo);
        
        if (generatedOrderId == null) {
            throw new Exception("존재하지 않는 주문 번호입니다: " + orderNo);
        }

        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus(approvalStatus);
        approvalDTO.setRequestEtpStatus(requestEtpStatus);
        approvalDTO.setApprUserNo(loginUserNo);
        approvalDTO.setRequestUserNo(loginUserNo);
        approvalDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
    }
    
    private void updateCartItems(Object cartIdsObj, String orderNo, String loginUserId) {
        try {
            List<Integer> idList = new ArrayList<>();

            if (cartIdsObj instanceof List) {
                List<?> rawList = (List<?>) cartIdsObj;
                for (Object obj : rawList) {
                    String val = String.valueOf(obj).trim();
                    if (!val.isEmpty() && !"null".equals(val)) {
                        idList.add(Integer.parseInt(val));
                    }
                }
            } else if (cartIdsObj instanceof String) {
                String str = (String) cartIdsObj;
                if (!str.isEmpty() && !"undefined".equals(str)) {
                    idList = Arrays.stream(str.split(","))
                            .map(String::trim)
                            .filter(id -> !id.isEmpty())
                            .map(Integer::parseInt)
                            .collect(Collectors.toList());
                }
            }

            if (!idList.isEmpty()) {
                Map<String, Object> cartParams = new HashMap<>();
                cartParams.put("orderNo", orderNo);
                cartParams.put("idList", idList);
                cartParams.put("userId", loginUserId);
                cartParams.put("status", "REQ");
                
                cartMapper.updateCartOrderInfo(cartParams);
            }
        } catch (Exception e) {
            System.err.println("!!! 장바구니 업데이트 중 오류 발생 !!!");
            e.printStackTrace();
        }
    }
}