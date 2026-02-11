package io.github.teamb.btob.controller.user;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Test {
	@GetMapping("/testjg/testjj")
	public String test() {
		return "testjg/testjj";
	}
}
