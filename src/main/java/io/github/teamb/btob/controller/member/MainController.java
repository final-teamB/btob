package io.github.teamb.btob.controller.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/")
    public String root() {
        // Run 하자마자 로그인 화면이 뜨도록 리다이렉트 설정
        return "redirect:/login"; 
    }

    @GetMapping("/main")
    public String mainPage() {
        return "testKSH/main"; 
    }
}