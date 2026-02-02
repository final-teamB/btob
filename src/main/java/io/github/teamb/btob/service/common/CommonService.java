package io.github.teamb.btob.service.common;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;

public interface CommonService {

	// 셀렉박스
	<T> List<T> getSelectBoxList(SelectBoxListDTO selectBoxListDTO, Class<T> targetDTO);
	
	// 변수 null, 공백 chk용
	boolean nullEmptyChkValidate(Object value);
}
