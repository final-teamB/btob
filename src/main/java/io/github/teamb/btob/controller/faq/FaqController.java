package io.github.teamb.btob.controller.faq;

import io.github.teamb.btob.entity.Faq;
import io.github.teamb.btob.service.faq.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/faq")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    @GetMapping
    public String list(Model model) {
        List<Faq> faqList = faqService.getActiveFaqList();
        model.addAttribute("faqList", faqList);
        model.addAttribute("categories", Faq.FaqCategory.values());
        model.addAttribute("content", "testKSH/faqList.jsp"); 
        return "layout/layout"; 
    }

    @PostMapping("/write")
    public String write(Faq faq, @AuthenticationPrincipal UserDetails userDetails) {
        // 작성자 및 수정자 설정
        String currentUserId = userDetails.getUsername();
        faq.setRegId(currentUserId);
        faq.setUpdId(currentUserId);
        
        faqService.saveFaq(faq);
        return "redirect:/faq";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        faqService.deleteFaq(id);
        return "redirect:/faq";
    }
}