package io.github.teamb.btob.controller.chat;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.chat.ChatRequest;
import io.github.teamb.btob.dto.chat.ChatResponse;
import io.github.teamb.btob.service.chat.ChatService;
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
