package io.github.teamb.btob.mapper.chat;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.chat.ChatbotDTO;

@Mapper
public interface ChatMapper {
	
	int insertChatLog (ChatbotDTO chatbotDTO);
}
