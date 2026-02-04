package io.github.teamb.btob.controller.trade;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import io.github.teamb.btob.service.trade.TradeApprovalService;

@Controller
@RequestMapping("/trade")
public class TradeApprovalController {
	private final TradeApprovalService tradeApprovalService;

	public TradeApprovalController(TradeApprovalService tradeApprovalService) {
		this.tradeApprovalService = tradeApprovalService;
	}
	
	@GetMapping("/pending")
	public String pending(Model model) {
		
		model.addAttribute("pageTitle", "견적/주문 요청 대기 목록");
		model.addAttribute("content", "/trade/pending.jsp");
		return "layout/layout";
	}
	
}
