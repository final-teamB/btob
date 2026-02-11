package io.github.teamb.btob.service.adminSupport;

import java.util.List;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.adminSupport.FaqDTO;
import io.github.teamb.btob.mapper.adminSupport.FaqMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FaqService {
	
	private final FaqMapper faqMapper;
	
	public List<FaqDTO> getFaqList(FaqDTO faqDTO) {
		
		return faqMapper.selectFaqList(faqDTO);
	}
	
	public FaqDTO getFaqDetail(int faqId) { 
		
		return faqMapper.selectFaqDetail(faqId); 
	}
	
    public boolean registerFaq(FaqDTO faqDTO) { 
    	
    	return faqMapper.insertFaq(faqDTO) > 0; 
    }
    
    public boolean modifyFaq(FaqDTO faqDTO) { 
    	
    	return faqMapper.updateFaq(faqDTO) > 0; 
    }
    
    public boolean removeFaq(int faqId, String updId) { 
    	
    	return faqMapper.deleteFaq(faqId, updId) > 0; 
    }
}
