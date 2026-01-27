package io.github.teamb.btob.controller.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/")
    public String root() {
        return "redirect:/login"; // 루트 접속 시 로그인으로 리다이렉트
    }

    @GetMapping("/main")
    public String mainPage() {
        return "testKSH/main"; 
    }
}