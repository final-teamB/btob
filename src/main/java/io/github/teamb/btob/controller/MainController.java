package io.github.teamb.btob.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/main")
    public String mainPage() {
        // src/main/webapp/WEB-INF/views/main.jsp
        return "main"; 
    }
}
