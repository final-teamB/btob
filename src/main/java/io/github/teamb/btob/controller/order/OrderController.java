package io.github.teamb.btob.controller.order;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.order.OrderHistoryDTO;
import io.github.teamb.btob.dto.order.OrderVoDTO;
import io.github.teamb.btob.dto.payment.PaymentVo;
import io.github.teamb.btob.service.order.OrderService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderController {
	private final OrderService orderService;
	private final LoginUserProvider loginUserProvider;
	
	// 1. 상세 페이지 조회 (모달용)
    @GetMapping("/detail")
    public String getOrderDetail(@RequestParam("orderId") int orderId, Model model) {
    	OrderVoDTO order = orderService.getFullOrderDetail(orderId);

        model.addAttribute("order", order);
        return "order/detail";
    }
	
	@GetMapping("/list")
    public String orderHistory(OrderHistoryDTO dto, Model model) {
    	String userId = loginUserProvider.getLoginUserId();
    	String userType = loginUserProvider.getUserType(userId);
    	dto.setRegId(userId);
    	
    	List<OrderHistoryDTO> orderList = orderService.selectUserOrderList(dto, userType);
    	
      	model.addAttribute("orderList", orderList);
    	model.addAttribute("pageTitle", "주문/배송 내역");  
    	model.addAttribute("userType", userType);
        model.addAttribute("content", "order/list.jsp"); 
        return "layout/layout"; 
    }

	@PostMapping("/orderSubmit")
	public ResponseEntity<?> orderSubmit(@RequestBody Map<String, Object> params) {
	    try {
	        orderService.processOrderRequest(params);
	        return ResponseEntity.ok().body(Map.of("result", "success"));
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return ResponseEntity.internalServerError().body(Map.of("message", e.getMessage()));
	    }
	}
	
	@PostMapping("/estSubmit")
	public ResponseEntity<?> estSubmit(@RequestBody Map<String, Object> params) {
		try {
			orderService.processEstRequest(params);
			return ResponseEntity.ok().body(Map.of("result", "success"));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().body(Map.of("message", e.getMessage()));
		}
	}
	
	@PostMapping("/modifyStatus")
	@ResponseBody
	public ResponseEntity<?> modifyStatus(@RequestBody Map<String, Object> params) {
	    try {
	     
	        // 서비스 호출
	        orderService.modifyOrderStatus(params);

	        return ResponseEntity.ok(Map.of("result", "success", "message", "정상 처리되었습니다."));
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body(Map.of("result", "fail", "message", e.getMessage()));
	    }
	}
}
