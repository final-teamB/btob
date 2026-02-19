package io.github.teamb.btob.controller.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.payment.PaymentRequestDTO;
import io.github.teamb.btob.dto.payment.PaymentViewDTO;
import io.github.teamb.btob.dto.payment.PaymentVo;
import io.github.teamb.btob.service.payment.PaymentService;
import lombok.RequiredArgsConstructor;


@Controller
@RequestMapping("/payment")
@RequiredArgsConstructor
public class PaymentController {
	private final PaymentService paymentService;
	private final LoginUserProvider loginUserProvider;
	
	@Value("${toss.client-key}")
    private String tossCk;
	
	@GetMapping("/payment")
	public String payment(@RequestParam("orderNo") String orderNo,Model model) {
		String userId = loginUserProvider.getLoginUserId();
		if (userId == null) return "redirect:/login";
		
		PaymentViewDTO paymentView = paymentService.getPaymentViewInfo(orderNo);
	    			
		model.addAttribute("paymentView", paymentView);
		model.addAttribute("tossCk", tossCk);
	
	    	    
	    return "payment/payment"; // 결제 전용 JSP로 이동
	}
	
	 // 2차 결제
    @GetMapping("/paySecond")
    public String paySecond(@RequestParam("orderNo") String orderNo, Model model) {
        // 결제에 필요한 금액 정보 등을 다시 조회
    	PaymentViewDTO paymentView = paymentService.getPaymentSecondViewInfo(orderNo);
    	model.addAttribute("tossCk", tossCk);
        model.addAttribute("paymentView", paymentView);
        return "payment/paySecond";
    }
	
    @GetMapping("/success")
    public String paymentSuccess(PaymentRequestDTO payment, Model model) {
        try {
            // 1. 토스 승인 및 DB 처리
            paymentService.confirmPayment(payment);

            // 2. 화면에 보여줄 데이터 담기
            model.addAttribute("orderNo", payment.getOrderNo());
            model.addAttribute("amount", payment.getAmount());
            
            // 3. 1차든 2차든 작성하신 success.jsp 하나로 리턴!
            return "payment/success"; 
            
        } catch (Exception e) {
        	model.addAttribute("errorCode", "CONFIRM_ERROR"); 
            model.addAttribute("errorMessage", e.getMessage());
            return "payment/fail";
        }
    }
    
	@GetMapping("/fail")
	public String paymentFail(
	        @RequestParam(required = false) String code,
	        @RequestParam(required = false) String message,
	        @RequestParam String orderNo,
	        @RequestParam(required = false) String payStep,
	        Model model) {

	    // 토스가 보내준 에러 메시지들을 화면에 전달
	    model.addAttribute("errorCode", code != null ? code : "UNKNOWN_ERROR");
	    model.addAttribute("errorMessage", message != null ? message : "결제 중 알 수 없는 오류가 발생했습니다.");
	    model.addAttribute("orderNo", orderNo);
	    model.addAttribute("payStep", payStep);
	    
	    return "payment/fail"; // payment/fail.jsp 호출
	}
	
}
