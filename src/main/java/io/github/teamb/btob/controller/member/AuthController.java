package io.github.teamb.btob.controller.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/home")
public class AuthController {
	
	@GetMapping("/login")
    public String loginPage() {
		
        return "testKSH/login";
    }
}
