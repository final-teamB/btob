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
		// 1. 주문 기본 정보 및 품목 리스트 조회 (DB 재조회)
	    // 보통 orderId 하나로 여러 품목이 나올 수 있도록 itemList로 가져옵니다.
	    List<TradePendingDTO> itemList = tradeDocService.getOrderDetailList(orderId);
	    
	    if (itemList != null && !itemList.isEmpty()) {
	        // 2. 상단 업체/요청자 정보 (리스트의 첫 번째 항목 기준)
	        model.addAttribute("info", itemList.get(0));
	        
	        // 3. 테이블에 뿌릴 품목 전체 리스트
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("userType", userType);
	        
	        // 4. cartIds 추출 (발주 승인 시 필요)
	        // 리스트 내의 모든 cartId를 콤마로 연결한 문자열 생성
	        String cartIds = itemList.stream()
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
	    List<TradePendingDTO> itemList = tradeDocService.getOrderDetailList(orderId);
	    
	    if (itemList != null && !itemList.isEmpty()) {
	        // 2. 상단 업체/요청자 정보 (리스트의 첫 번째 항목 기준)
	        model.addAttribute("info", itemList.get(0));
	        
	        // 3. 테이블에 뿌릴 품목 전체 리스트
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("userType", userType);
	        
	        // 4. cartIds 추출 (발주 승인 시 필요)
	        // 리스트 내의 모든 cartId를 콤마로 연결한 문자열 생성
	        String cartIds = itemList.stream()
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