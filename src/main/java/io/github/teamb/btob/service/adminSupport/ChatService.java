package io.github.teamb.btob.service.adminSupport;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.adminSupport.ChatbotDTO;
import io.github.teamb.btob.dto.adminSupport.FaqDTO;
import io.github.teamb.btob.mapper.adminSupport.ChatMapper;
import io.github.teamb.btob.mapper.adminSupport.FaqMapper;

@Service
public class ChatService {
 
	private final ChatClient chatClient;
	private final ChatMapper chatMapper;
	private final FaqMapper faqMapper;
	
	public ChatService(ChatClient.Builder builder, ChatMapper chatMapper, FaqMapper faqMapper) {
        this.chatClient = builder.build(); 
        this.chatMapper = chatMapper;
        this.faqMapper = faqMapper;
    }
	
	public String ask(String question) {
		String answer;
        
        // TB_FAQ에서 먼저 답변이 있는지 확인
        FaqDTO faq = faqMapper.selectFaqByChatbot(question);
        
        if (faq != null && faq.getAnswer() != null) {
            // DB에 데이터가 있으면 해당 답변을 즉시 반환
            answer = "[FAQ] " + faq.getAnswer();
        } else {
            // DB에 없으면 AI에게 물어봄
            answer = chatClient.prompt()
                    .system("너는 b2b 기름 유통 시스템 고객지원 챗봇이다. "
                          + "배송, 주문, 회원 문의에 대해 관리자 관점에서 정확하게 답변해라.")
                    .user(question)
                    .call()
                    .content();
        }
		
        // 대화 이력 저장
		ChatbotDTO dto = new ChatbotDTO();
		dto.setQuestion(question);
		dto.setAnswer(answer);
		dto.setUserNo(1);
		
		chatMapper.insertChatLog(dto);
		
		return answer;
	}
}
