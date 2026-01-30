package io.github.teamb.btob.mapper.common;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;

@Mapper
public interface CommonMapper {
	
	// 셀렉박스 추출
	List<Map<String, Object>> selectBoxList(SelectBoxListDTO selectBoxListDTO); 
}
