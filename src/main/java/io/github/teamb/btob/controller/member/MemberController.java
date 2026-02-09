package io.github.teamb.btob.controller.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping("/register")
    public String registerPage() {
        return "testKSH/register";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "testKSH/login";
    }

    @GetMapping("/mypage")
    public String myPage(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        MemberDto myInfo = memberService.getMyInfo(userDetails.getUsername());
        model.addAttribute("user", myInfo);
        model.addAttribute("content", "testKSH/mypage.jsp");
        return "layout/layout";
    }

    @PostMapping("/register")
    public String register(MemberDto memberDto) {
        // [수정] MemberDto의 userType이 String이므로 문자열로 비교 및 설정합니다.
        // "MASTER"가 아닌 모든 권한 요청(ADMIN 포함)은 "USER"로 강제 변환합니다.
        if (!"MASTER".equals(memberDto.getUserType())) {
            memberDto.setUserType("USER");
        }
        
        log.info("회원가입 요청: ID={}, 권한={}, 주소={}", 
                 memberDto.getUserId(), memberDto.getUserType(), memberDto.getAddress());
        
        memberService.register(memberDto);
        return "redirect:/login";
    }

    @PostMapping("/mypage/update")
    public String updateInfo(MemberDto memberDto) {
        memberService.updateInfo(memberDto);
        return "redirect:/mypage";
    }
}