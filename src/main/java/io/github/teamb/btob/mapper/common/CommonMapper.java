package io.github.teamb.btob.mapper.common;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;

@Mapper
public interface CommonMapper {
	
	// 셀렉박스 추출
	List<SelectBoxVO> selectBoxList(SelectBoxListDTO selectBoxListDTO); 
}
