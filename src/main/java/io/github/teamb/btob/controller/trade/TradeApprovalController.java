package io.github.teamb.btob.controller.trade;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import io.github.teamb.btob.dto.trade.EstimateDetailDTO;
import io.github.teamb.btob.dto.trade.OrderDetailDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.service.document.TradeDocService;
import io.github.teamb.btob.service.trade.TradeApprovalService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/trade")
@RequiredArgsConstructor
public class TradeApprovalController {
	private final TradeApprovalService tradeApprovalService;
	private final TradeDocService tradeDocService;
	private final LoginUserProvider loginUserProvider;
	
	@GetMapping("/pendingCount")
	@ResponseBody
	public int getPendingCount() {
	    // 1. 현재 로그인한 사용자의 ID나 회사 정보를 가져옵니다.
	    String userId = loginUserProvider.getLoginUserId();
	    
	    // 2. 서비스 레이어에서 결재 대기 중인(예: status = 'WAITING') 건수를 조회합니다.
	    // (이 로직은 이미 구현된 Service 메서드를 활용하세요)
	    int count = tradeApprovalService.selectPendingCount(userId);
	    
	    return count; 
	}
	
	@GetMapping("/pending")
	public String pending(TradePendingDTO dto, Model model) {
		List<TradePendingDTO> pendingList =  tradeApprovalService.getTradePendingList(dto);
		
		model.addAttribute("pageTitle", "견적/주문 승인 대기 목록");
		model.addAttribute("content", "/trade/pending.jsp");
		model.addAttribute("pendingList", pendingList);
		return "layout/layout";
	}
		
	@GetMapping("/approveEst")
	public String previewEst(@RequestParam(value="orderId", required=false) Integer orderId, Model model) {
	    String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());

	    // 1. 단일 DTO로 가져옵니다 (그 안에 List<OrderItemDTO>가 포함된 구조)
	    EstimateDetailDTO detail = tradeDocService.getEstimateDetail(orderId);
	    
	    if (detail != null) {
	        model.addAttribute("info", detail); // 상단 업체 정보 등
	        model.addAttribute("itemList", detail.getItemList()); // 실제 품목 리스트
	        model.addAttribute("userType", userType);
	        
	        // 2. 이제 detail.getItemList()에서 스트림을 돌립니다.
	        // ItemDTO에는 cartId가 있으므로 에러가 사라집니다.
	        String cartIds = detail.getItemList().stream()
	                                 .map(item -> String.valueOf(item.getCartId()))
	                                 .collect(Collectors.joining(","));
	        model.addAttribute("cartIds", cartIds);
	    }
	    
	    return "document/approveEst";
	}
	@GetMapping("/previewOrder")
	public String previewOrder(@RequestParam(value="orderId", required=false) Integer orderId, Model model) {
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
		// 1. 주문 기본 정보 및 품목 리스트 조회 (DB 재조회)
	    // 보통 orderId 하나로 여러 품목이 나올 수 있도록 itemList로 가져옵니다.
	    OrderDetailDTO detail = tradeDocService.getOrderDetail(orderId);
	    
	    if (detail != null) {
	        model.addAttribute("info", detail); // 상단 업체 정보 등
	        model.addAttribute("itemList", detail.getItemList()); // 실제 품목 리스트
	        model.addAttribute("userType", userType);
	        
	        // 2. 이제 detail.getItemList()에서 스트림을 돌립니다.
	        // ItemDTO에는 cartId가 있으므로 에러가 사라집니다.
	        String cartIds = detail.getItemList().stream()
	                                 .map(item -> String.valueOf(item.getCartId()))
	                                 .collect(Collectors.joining(","));
	        model.addAttribute("cartIds", cartIds);
	    }

	    return "document/previewOrder";
	}
	
	/**
	 * 승인 및 반려 처리 (AJAX 전송용)
	 */
	@PostMapping("/processApproval")
	@ResponseBody
	public ResponseEntity<String> processApproval(@RequestBody Map<String, Object> params) {
	    try {
	        tradeApprovalService.updateOrderStatus(params);
	        return ResponseEntity.ok("처리가 완료되었습니다."); // 성공 시 200 OK
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body("오류 발생: " + e.getMessage()); // 실패 시 500 Error
	    }
	}
}