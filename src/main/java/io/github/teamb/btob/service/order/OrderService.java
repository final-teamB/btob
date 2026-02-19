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
import io.github.teamb.btob.dto.est.EstDocInsertDTO;
import io.github.teamb.btob.dto.est.EstReqDTO;
import io.github.teamb.btob.dto.order.OrderDTO;
import io.github.teamb.btob.dto.order.OrderHistoryDTO;
import io.github.teamb.btob.dto.order.OrderVoDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;
import io.github.teamb.btob.mapper.order.OrderMapper;
import io.github.teamb.btob.mapper.payment.PaymentMapper;
import io.github.teamb.btob.mapper.user.UserMapper;
import io.github.teamb.btob.service.BizWorkflow.BizWorkflowService;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {
    private final OrderMapper orderMapper;
    private final CartMapper cartMapper;
    private final BizWorkflowService bizWorkflowService; 
    private final LoginUserProvider loginUserProvider;
    private final NotificationService notificationService;
    private final UserMapper usermapper;
    
    public OrderVoDTO getFullOrderDetail(String orderNo) {
        return orderMapper.getOrderDetailWithAll(orderNo);
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
        
        String masterId = usermapper.selectMasterIdByUserId(loginUserId);
        if (masterId != null) {
            notificationService.send(masterId, "ORDER", generatedOrderId, 
                "새로운 주문 승인 요청이 있습니다. (번호: " + orderNo + ")", loginUserId);
        }

        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus("COMPLETE");
        approvalDTO.setRequestEtpStatus(nextStatus);
        approvalDTO.setApprUserNo("");
        approvalDTO.setRequestUserNo(loginUserId);
        approvalDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
        updateCartItems(params.get("cartIds"), orderNo, loginUserId);
    }
    
    public void processEstRequest(EstReqDTO dto) throws Exception {
        Integer loginUserNo = loginUserProvider.getLoginUserNo();
        String loginUserId = loginUserProvider.getLoginUserId();
        if (loginUserId == null || loginUserNo == null) throw new Exception("세션이 만료되었습니다.");

        String systemId = "ESTIMATE"; 
        String nextStatus = "et002"; 
        
        String estNo = orderMapper.selectFormattedEstNo(systemId, loginUserId);
        
        EstDocInsertDTO docDto = EstDocInsertDTO.builder()
                .estNo(estNo)
                .companyName((String) dto.getCompanyName())
                .companyPhone((String) dto.getCompanyPhone())
                .requestUserId(loginUserNo)
                .ctrtNm(dto.getCtrtNm())
                .estStatus(nextStatus)
                .baseTotalAmount(dto.getBaseTotalAmount())
                .targetTotalAmount(dto.getTargetTotalAmount())
                .estdtMemo(dto.getEstdtMemo())
                .regId(loginUserId)
                .build();
        
        orderMapper.insertEstDoc(docDto);
        Integer generatedEstId = docDto.getEstDocId();
        
        ApprovalDecisionRequestDTO estDTO = new ApprovalDecisionRequestDTO();
        estDTO.setSystemId(systemId);
        estDTO.setRefId(generatedEstId);
        estDTO.setApprovalStatus("COMPLETE");
        estDTO.setRequestEtpStatus(nextStatus);
        estDTO.setApprUserNo("");
        estDTO.setRequestUserNo(loginUserId);
        estDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(estDTO);
        
        String orderNo = orderMapper.selectFormattedOrderNo("ORDER", loginUserId);
               
        OrderDTO orderDto = OrderDTO.builder()
                .orderNo(orderNo)
                .estId(generatedEstId)
                .userNo(loginUserNo)
                .orderStatus(nextStatus)
                .regId(loginUserId)
                .useYn("Y")
                .build();
        
        orderMapper.upsertOrderMaster(orderDto);
        int generatedOrderId = orderDto.getOrderId(); 
        
        List<String> adminIds = usermapper.selectAllAdminIds();
        if (adminIds != null && !adminIds.isEmpty()) {
            for (String adminId : adminIds) {
                notificationService.send(
                    adminId,            // 수신자: 관리자들
                    "ORDER", 
                    generatedEstId, 
                    "새로운 견적 승인 요청이 있습니다. (번호: " + orderNo + ")", 
                    loginUserId         // 발신자: 요청 유저
                );
            }
        }
                
        String orderSystemId = "ORDER";
        
        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(orderSystemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus("COMPLETE");
        approvalDTO.setRequestEtpStatus(nextStatus);
        approvalDTO.setApprUserNo("");
        approvalDTO.setRequestUserNo(loginUserId);
        approvalDTO.setUserId(loginUserId);

        bizWorkflowService.modifyEtpStatusAndLogHist(approvalDTO);
        
        
        Map<String, Object> cartParams = new HashMap<>();
        cartParams.put("orderNo", orderNo);
        cartParams.put("userId", loginUserId);
        cartParams.put("cartStatus", "REQ");
        cartParams.put("itemList", dto.getItemList());
        
        cartMapper.updateCartEstInfo(cartParams);
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
        OrderVoDTO orderDetail = orderMapper.getOrderDetailWithAll(orderNo);
        
        if (generatedOrderId == null) {
            throw new Exception("존재하지 않는 주문 번호입니다: " + orderNo);
        }

     // --- [알림 발송 로직 시작] ---
        if (orderDetail != null && "COMPLETE".equals(approvalStatus)) {
            
            // 1. 대표 승인 요청 (od001) -> 해당 회사의 MASTER에게 알림
            if ("od001".equals(requestEtpStatus)) {
                String masterId = usermapper.selectMasterIdByUserId(loginUserId);
                if (masterId != null) {
                    notificationService.send(
                        masterId, 
                        "ORDER", 
                        generatedOrderId, 
                        "주문 승인 요청: [" + orderNo + "] 건에 대해 대표 승인 바랍니다.", 
                        loginUserId
                    );
                }
            } 
            
            // 2. 구매 승인 요청 (pr001) -> 모든 ADMIN(관리자)에게 알림
            else if ("pr001".equals(requestEtpStatus)) {
                List<String> adminIds = usermapper.selectAllAdminIds();
                if (adminIds != null) {
                    for (String adminId : adminIds) {
                        notificationService.send(
                            adminId, 
                            "ORDER", 
                            generatedOrderId, 
                            "구매 승인 요청: [" + orderNo + "] 최종 구매 승인 검토 바랍니다.", 
                            loginUserId
                        );
                    }
                }
            }
        }
        
        ApprovalDecisionRequestDTO approvalDTO = new ApprovalDecisionRequestDTO();
        approvalDTO.setSystemId(systemId);
        approvalDTO.setRefId(generatedOrderId);
        approvalDTO.setApprovalStatus(approvalStatus);
        approvalDTO.setRequestEtpStatus(requestEtpStatus);
        approvalDTO.setApprUserNo(loginUserId);
        approvalDTO.setRequestUserNo(loginUserId);
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
                cartParams.put("cartStatus", "REQ");
                
                cartMapper.updateCartOrderInfo(cartParams);
            }
        } catch (Exception e) {
            System.err.println("!!! 장바구니 업데이트 중 오류 발생 !!!");
            e.printStackTrace();
        }
    }
}