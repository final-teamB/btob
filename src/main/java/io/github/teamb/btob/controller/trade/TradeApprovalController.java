package io.github.teamb.btob.controller.trade;

import java.util.ArrayList;
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

import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.service.trade.TradeApprovalService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/trade")
@RequiredArgsConstructor
public class TradeApprovalController {
	private final TradeApprovalService tradeApprovalService;
	
	@GetMapping("/pending")
	public String pending(TradePendingDTO dto, Model model) {
		List<TradePendingDTO> pendingList =  tradeApprovalService.getTradePendingList(dto);
		
		model.addAttribute("pageTitle", "견적/주문 승인 대기 목록");
		model.addAttribute("content", "/trade/pending.jsp");
		model.addAttribute("pendingList", pendingList);
		return "layout/layout";
	}
		
	/**
     * 견적서 미리보기 (POST 전용)
     */
	@PostMapping("/previewEst")
	public String previewEst(@RequestParam Map<String, Object> params, Model model) {
	    
	    // 1. 기존 JSP 규격 맞추기 (리스트화)
	    List<Map<String, Object>> itemList = new ArrayList<>();
	    itemList.add(params);
	    model.addAttribute("itemList", itemList);
	    
	    // 2. JSP 하단 버튼 및 스크립트용 데이터
	    model.addAttribute("cartIds", params.get("cartIds"));
	    model.addAttribute("totalSum", params.get("totalPrice"));

	    // 3. [핵심] 마스터 전용 페이지이므로 권한을 MASTER로 고정
	    // 이렇게 하면 JSP의 <c:when test="${user_type eq 'MASTER'}"> 블록이 무조건 실행됩니다.
	    model.addAttribute("user_type", "MASTER");

	    return "document/previewEst"; 
	}

    /**
     * 발주서 미리보기 (POST 전용)
     */
	@PostMapping("previewOrder")
	public String previewOrder(@RequestParam Map<String, Object> params, Model model) {
	    
	    // 1. 기존 JSP 규격 맞추기 (리스트화)
	    List<Map<String, Object>> itemList = new ArrayList<>();
	    itemList.add(params);
	    model.addAttribute("itemList", itemList);
	    
	    // 2. JSP 하단 버튼 및 스크립트용 데이터
	    model.addAttribute("cartIds", params.get("cartIds"));
	    model.addAttribute("totalSum", params.get("totalPrice"));

	    // 3. [핵심] 마스터 전용 페이지이므로 권한을 MASTER로 고정
	    model.addAttribute("user_type", "MASTER");

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