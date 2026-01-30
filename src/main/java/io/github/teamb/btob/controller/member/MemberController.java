package io.github.teamb.btob.controller.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j; // 로그 확인용
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
        return "testKSH/mypage";
    }

    @PostMapping("/register")
    public String register(MemberDto memberDto) {
        // 주소와 권한 정보가 잘 들어오는지 로그로 확인 가능합니다.
        log.info("회원가입 요청: ID={}, 권한={}, 주소={}", 
                 memberDto.getUserId(), memberDto.getUserType(), memberDto.getAddress());
        
        memberService.register(memberDto);
        return "redirect:/login";
    }

    @PostMapping("/mypage/update")
    public String updateInfo(MemberDto memberDto) {
        memberService.updateInfo(memberDto);
        return "redirect:/mypage?success=true";
    }
}