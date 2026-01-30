package io.github.teamb.btob.controller.chat;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.teamb.btob.dto.chat.FaqDTO;
import io.github.teamb.btob.service.chat.FaqService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/chat")
@RequiredArgsConstructor
public class FaqController {

	private final FaqService faqService;
	
	@GetMapping("/faqList")
	public String Faqlist(FaqDTO faqDTO, Model model) {
		
		model.addAttribute("faqList", faqService.getFaqList(faqDTO));
		
		return "test/chat/faqList";
	}
	
	@GetMapping("/registerFaq")
	public String registerFaqForm() {
		
		return "test/chat/faqForm";
	}
	@PostMapping("/registerFaq")
	public String registerFaq(FaqDTO faqDTO, Principal principal, RedirectAttributes reAttributes) {
		
		faqDTO.setRegId(principal != null ? principal.getName() : "admin");
		if (faqService.registerFaq(faqDTO)) {
	        reAttributes.addFlashAttribute("msg", "등록되었습니다.");
	    }
        return "redirect:/admin/chat/faqList";
	}
	
	@GetMapping("/modifyFaq/{faqId}")
	public String modifyFaq(@PathVariable int faqId, Model model) {
		
		model.addAttribute("faq", faqService.getFaqDetail(faqId));
		
		return "test/chat/faqForm";
	}
	@PostMapping("/modifyFaq")
	public String modifyFaq(FaqDTO faqDTO, Principal principal, RedirectAttributes reAttributes) {
		
		faqDTO.setUpdId(principal != null ? principal.getName() : "admin");
		if (faqService.modifyFaq(faqDTO)) {
	        reAttributes.addFlashAttribute("msg", "수정되었습니다.");
	    }
		return "redirect:/admin/chat/faqList";
	}
	
	@PostMapping("/removeFaq")
	public String removeFaq(int faqId) {
		
		return faqService.removeFaq(faqId) ? "삭제성공" : "삭제실패";
	}
}
