package io.github.teamb.btob.controller;

import io.github.teamb.btob.dto.MemberDto;
import io.github.teamb.btob.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    // 회원가입 페이지
    @GetMapping("/register")
    public String registerPage() {
        return "register"; // register.jsp 호출
    }

    // 회원가입 처리
    @PostMapping("/register")
    public String register(MemberDto memberDto) {
        memberService.register(memberDto);
        return "redirect:/login"; // 가입 완료 후 로그인 페이지로 이동
    }
    
    // 로그인 페이지
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
}
