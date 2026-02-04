package io.github.teamb.btob.controller.index;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/index")
public class IndexController {

	@GetMapping("/main")
    public String main(Model model) {
        
    
        List<Map<String, Object>> userList = new ArrayList<>();
        
        Map<String, Object> user1 = new HashMap<>();
        user1.put("userNo", "1");
        user1.put("userName", "홍길동");
        user1.put("role", "일반사용자");
        user1.put("regDtime", "2024-01-29");
        user1.put("status", "Active");
        userList.add(user1);
        
        Map<String, Object> user2 = new HashMap<>();
        user2.put("userNo", "2");
        user2.put("userName", "김철수");
        user2.put("role", "관리자");
        user2.put("regDtime", "2024-01-28");
        user2.put("status", "Inactive");
        userList.add(user2);

        // 2. 핵심!! "userList"라는 이름으로 데이터를 모델에 담아야 JSP가 읽을 수 있습니다.
        model.addAttribute("userList", userList);
        
        model.addAttribute("content", "layout/sample.jsp");
        model.addAttribute("pageTitle", "Dashboard");
        
        return "layout/layout";
    }
	
//	@GetMapping("/user")
//    public String user(Model model) {
//        model.addAttribute("content", "/WEB-INF/views/layout/user.jsp");
//        model.addAttribute("pageTitle", "User Page");
//        return "layout/layout";
//    }
}
