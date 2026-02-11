package io.github.teamb.btob.controller.home;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/home")
public class HomeIdxController {
	
	@GetMapping("/index")
	public String homeIdx() {
		
		return "home/homeIndex";
	}
	
	@GetMapping("/chkk")
	public String chkk() {
		
		return "document/previewEst";
	}

}
