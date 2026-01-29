package io.github.teamb.btob.controller.index;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/index")
public class IndexController {

	@GetMapping("/main")
	public String main(Model model) {
		
		model.addAttribute("content", "/WEB-INF/views/layout/sample.jsp"); // 웹 브라우저 탭 제목 /WEB-INF/views/의 다음 경로부터만 적어주세요
		model.addAttribute("pageTitle", "Dashboard"); // <main>에 들어갈 실제 파일 경로
		return "layout/layout"; // 최종적으로는 항상 layout.jsp를 호출

	}
	
//	@GetMapping("/user")
//    public String user(Model model) {
//        model.addAttribute("content", "/WEB-INF/views/layout/user.jsp");
//        model.addAttribute("pageTitle", "User Page");
//        return "layout/layout";
//    }
}
