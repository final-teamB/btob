package io.github.teamb.btob.controller.order;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.service.order.OrderService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderController {
	private final OrderService orderService;

	@PostMapping("/orderSubmit")
	public ResponseEntity<?> orderSubmit(@RequestBody Map<String, Object> params) {
	    try {
	        orderService.processOrderRequest(params);
	        return ResponseEntity.ok().body(Map.of("result", "success"));
	    } catch (Exception e) {
	        return ResponseEntity.internalServerError().body(Map.of("message", e.getMessage()));
	    }
	}
	
	@PostMapping("/estSubmit")
	public ResponseEntity<?> estSubmit(@RequestBody Map<String, Object> params) {
		try {
			orderService.processEstRequest(params);
			return ResponseEntity.ok().body(Map.of("result", "success"));
		} catch (Exception e) {
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
