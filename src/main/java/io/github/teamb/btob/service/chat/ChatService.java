package io.github.teamb.btob.service.chat;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.chat.ChatbotDTO;
import io.github.teamb.btob.mapper.chat.ChatMapper;
import lombok.RequiredArgsConstructor;

@Service
public class ChatService {
 
	private final ChatClient chatClient;
	private final ChatMapper chatMapper;
	
	public ChatService(ChatClient.Builder builder, ChatMapper chatMapper) {
        this.chatClient = builder.build(); 
        this.chatMapper = chatMapper;
    }
	
	public String ask(String question) {
		String answer =  chatClient.prompt()
				.system("너는 b2b 기름 유통 시스템 고객지원 챗봇이다."
						+ "배송, 주문, 회원 문의에 대해 관리자 관점에서 정확하게 답변해라")
				.user(question)
				.call()
				.content();
		
		ChatbotDTO dto = new ChatbotDTO();
		dto.setQuestion(question);
		dto.setAnswer(answer);
		dto.setUserNo(1);
		
		chatMapper.insertChatLog(dto);
		
		return answer;
	}
}
