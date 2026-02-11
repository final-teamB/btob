package io.github.teamb.btob.controller.adminSupport;

import java.security.Principal;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.teamb.btob.dto.adminSupport.FaqDTO;
import io.github.teamb.btob.service.adminSupport.FaqService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/support")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    // 레이아웃 적용 공통 메서드
    private String renderLayout(Model model, String contentPath, String title) {
        // null 체크 및 경로 강제 지정 
        if (contentPath == null) {
        	contentPath = "adminFaqList.jsp"; 
        }
        model.addAttribute("content", "adminsh/adminSupport/" + contentPath); 
        model.addAttribute("pageTitle", title);
        return "layout/layout"; 
    }

    // 1. FAQ 리스트 조회 
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/faqList")
    public String faqList(FaqDTO faqDTO, Model model) {
    	
        model.addAttribute("faqList", faqService.getFaqList(faqDTO));
        return renderLayout(model, "adminFaqList.jsp", "FAQ 관리 리스트");
    }
    
    // 1-1. 사용자용 FAQ리스트 조회
    @GetMapping("/user/faqList")
    public String userFaqList(FaqDTO faqDTO, Model model) {
    	
        model.addAttribute("faqList", faqService.getFaqList(faqDTO));
        
        model.addAttribute("content", "adminsh/adminSupport/userFaqList.jsp"); 
        model.addAttribute("pageTitle", "자주 묻는 질문");
        return "layout/layout"; 
    }

    // 2. 등록 
    // 등록 폼 이동 (faqForm.jsp 리턴)
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/registerFaq")
    public String registerFaqForm(Model model) {
    	
        model.addAttribute("faq", new FaqDTO()); 
        return renderLayout(model, "adminFaqForm.jsp", "FAQ 신규 등록");
    }

    // 등록 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/admin/registerFaq")
    public String registerFaq(FaqDTO faqDTO, Principal principal, 
    						  @AuthenticationPrincipal UserDetails userDetails,
    						  RedirectAttributes reAttributes) {
        
    	String adminId = (userDetails != null) ? userDetails.getUsername() : "admin";
        
    	faqDTO.setRegId(adminId);
        faqDTO.setUpdId(adminId);
        
        if (faqService.registerFaq(faqDTO)) {
            reAttributes.addFlashAttribute("msg", "등록되었습니다.");
        }
        return "redirect:/support/admin/faqList";
    }

    // 3. 수정 
    // 수정 폼 이동 (faqForm.jsp 리턴)
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/modifyFaq/{faqId}")
    public String modifyFaq(@PathVariable("faqId") int faqId, Model model) {
    	
        model.addAttribute("faq", faqService.getFaqDetail(faqId));
        return renderLayout(model, "adminFaqForm.jsp", "FAQ 내용 수정");
    }

    // 수정 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/admin/modifyFaq")
    public String modifyFaq(FaqDTO faqDTO, 
    						@AuthenticationPrincipal UserDetails userDetails,
    						RedirectAttributes reAttributes) {
    	
    	String adminId = (userDetails != null) ? userDetails.getUsername() : "admin";
        faqDTO.setUpdId(adminId);
        
        if (faqService.modifyFaq(faqDTO)) {
            reAttributes.addFlashAttribute("msg", "수정되었습니다.");
        }
        return "redirect:/support/admin/faqList";
    }

    // 4. 삭제 처리 
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/removeFaq")
    @ResponseBody
    public boolean removeFaq(@RequestParam("faqId") int faqId,
    						 @AuthenticationPrincipal UserDetails userDetails) {

    	String adminId = (userDetails != null) ? userDetails.getUsername() : "admin";
    	return faqService.removeFaq(faqId, adminId);
    }
}