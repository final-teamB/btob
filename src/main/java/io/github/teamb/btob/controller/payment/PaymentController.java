package io.github.teamb.btob.controller.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.dto.payment.PaymentRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentViewDTO;
import io.github.teamb.btob.service.payment.PaymentService;
import lombok.RequiredArgsConstructor;


@Controller
@RequestMapping("/payment")
@RequiredArgsConstructor
public class PaymentController {
	private final PaymentService paymentService;
	@Value("${toss.client-key}")
    private String tossCk;
	
	@GetMapping("/payment")
	public String payment(@RequestParam("orderNo") String orderNo, Model model) {
		PaymentViewDTO paymentView = paymentService.getPaymentViewInfo(orderNo);
	    			
		model.addAttribute("paymentView", paymentView);
		model.addAttribute("tossCk", tossCk);
		model.addAttribute("pageTitle", "1차 결제 페이지");
		model.addAttribute("content", "payment/payment");
	    	    
	    return "layout/layout"; // 결제 전용 JSP로 이동
	}
	
	@GetMapping("/success")
	public String paymentSuccess(
			PaymentRequestDTO payment,
	        Model model) {

	    try {
	        // 1. 서비스에서 토스 승인 API 호출 및 DB 업데이트(상태 변경 등) 수행
	        // 결제 금액이 실제 DB와 맞는지 검증 로직이 서비스에 포함되어야 함
	        paymentService.confirmPayment(payment);

	        // 2. 성공 화면에 보여줄 정보 담기
	        model.addAttribute("orderNo", payment.getOrderNo());
	        model.addAttribute("amount", payment.getAmount());
	   	        
	        return "payment/success";
	        
	    } catch (Exception e) {
	        // 승인 실패 시 에러 페이지로
	        model.addAttribute("message", e.getMessage());
	        return "payment/fail";
	    }
	}
	
	@GetMapping("/fail")
	public String paymentFail(
	        @RequestParam(required = false) String code,
	        @RequestParam(required = false) String message,
	        @RequestParam(required = false) String orderNo,
	        Model model) {

	    // 토스가 보내준 에러 메시지들을 화면에 전달
	    model.addAttribute("errorCode", code != null ? code : "UNKNOWN_ERROR");
	    model.addAttribute("errorMessage", message != null ? message : "결제 중 알 수 없는 오류가 발생했습니다.");
	    model.addAttribute("orderNo", orderNo);
	    
	    return "payment/fail"; // payment/fail.jsp 호출
	}
	
}
