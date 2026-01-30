package io.github.teamb.btob.service.common;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;

public interface CommonService {

	// 셀렉박스
	<T> List<T> getSelectBoxList(SelectBoxListDTO selectBoxListDTO, Class<T> targetDTO);
	
	// map 변수 null chk용
	boolean nullEmptyChkValidate(Map<String, Object> paramMaps);
}
