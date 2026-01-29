package io.github.teamb.btob.service.common;

import java.util.List;
import java.util.Map;

public interface CommonService {

	// 셀렉박스
	<T> List<T> getSelectBoxList(String param, Class<T> targetDTO);
	
	// 변수null chk용
	boolean nullEmptyChkValidate(Map<String, Object> paramMaps);
}
