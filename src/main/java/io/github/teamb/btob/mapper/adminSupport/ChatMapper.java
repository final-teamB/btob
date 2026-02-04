package io.github.teamb.btob.mapper.adminSupport;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.adminSupport.ChatbotDTO;

@Mapper
public interface ChatMapper {
	
	int insertChatLog (ChatbotDTO chatbotDTO);
}
