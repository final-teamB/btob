package io.github.teamb.btob.controller.adminSupport;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.adminSupport.ChatRequest;
import io.github.teamb.btob.dto.adminSupport.ChatResponse;
import io.github.teamb.btob.service.adminSupport.ChatService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/chat")
@RequiredArgsConstructor
public class ChatController {

	private final ChatService chatService;
	
	@PostMapping
	@ResponseBody
	public ChatResponse chat(@RequestBody ChatRequest chatRequest) {
		
		String answer = chatService.ask(chatRequest.getMessage());
		return new ChatResponse(answer);
	}
	
	@GetMapping("/chatbot") 
	public String chatbotPage() {
	    return "test/chat/chatbot"; 
	}
}
