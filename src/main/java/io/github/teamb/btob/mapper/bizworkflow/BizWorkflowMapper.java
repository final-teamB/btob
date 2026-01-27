package io.github.teamb.btob.mapper.bizworkflow;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.bizworkflow.QtcHistDTO;
import io.github.teamb.btob.dto.bizworkflow.QtcStatusDTO;


@Mapper
public interface BizWorkflowMapper {
	
	// 견적/주문/결제 상태코드 값 변경
	void updateStatusCd(QtcStatusDTO qtcStatusDTO);
	
	// 견적/주문/결제 단계 이력
	void updateStatusHist(QtcHistDTO qtcHistDTO);
}
