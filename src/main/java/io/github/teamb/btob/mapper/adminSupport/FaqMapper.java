package io.github.teamb.btob.mapper.adminSupport;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.adminSupport.FaqDTO;

@Mapper
public interface FaqMapper {

	List<FaqDTO> selectFaqList(FaqDTO faqDTO);
	
	FaqDTO selectFaqDetail(@Param("faqId") int faqId);
	
	int insertFaq(FaqDTO faqDTO);
	
	int updateFaq(FaqDTO faqDTO);
	
	int deleteFaq(@Param("faqId") int faqId, @Param("updId") String updId); // use_yn = 'N' 처리
	
	// 챗봇 faq 검색
	FaqDTO selectFaqByChatbot(@Param("question") String question);
}
