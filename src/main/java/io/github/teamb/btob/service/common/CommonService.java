package io.github.teamb.btob.service.common;

import java.util.List;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;

public interface CommonService {

	// 셀렉박스
	List<SelectBoxVO> getSelectBoxList(SelectBoxListDTO selectBoxListDTO);
	
	// 변수 null, 공백 chk용
	boolean nullEmptyChkValidate(Object value);
}
