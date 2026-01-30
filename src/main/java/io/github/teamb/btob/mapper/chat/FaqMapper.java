package io.github.teamb.btob.mapper.chat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.chat.FaqDTO;

@Mapper
public interface FaqMapper {

	List<FaqDTO> selectFaqList(FaqDTO faqDTO);
	
	FaqDTO selectFaqDetail(int faqId);
	
	int insertFaq(FaqDTO faqDTO);
	
	int updateFaq(FaqDTO faqDTO);
	
	int deleteFaq(int faqId); // use_yn = 'N' 처리
	
	// 챗봇 faq 검색
	FaqDTO selectFaqByChatbot(String question);
}
