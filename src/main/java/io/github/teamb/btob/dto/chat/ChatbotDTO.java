package io.github.teamb.btob.dto.chat;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatbotDTO {
	private int chatId;
	private String question;
	private String answer;
	
	private LocalDateTime regDtime;
	private String regId;
	private LocalDateTime updDtime;
	private String updId;
	private String useYn;
	private int userNo;
}
