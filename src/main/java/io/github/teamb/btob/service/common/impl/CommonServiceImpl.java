package io.github.teamb.btob.service.common.impl;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.mapper.common.CommonMapper;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommonServiceImpl implements CommonService{
	
	private final CommonMapper commonMapper;
	

	/**
	 * 
	 * 셀렉박스 추출 유틸리티 메서드
	 * @author GD
	 * @since 2026. 1. 28.
	 * @param <T>
	 * @param param
	 * @param targetDTO
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 28.  GD       최초 생성
	 */
	@Override
	public List<SelectBoxVO> getSelectBoxList(SelectBoxListDTO dto) {
	    
	    
		// 파라미터 검증만 하고 바로 던지면 끝!
		if (dto.getCommonTable() == null || dto.getCommNo() == null) {
	        throw new IllegalArgumentException("필수 파라미터 누락");
	    }
	    
	    // 결과가 자동으로 SelectBoxVO(value, text)에 매핑됨
	    return commonMapper.selectBoxList(dto);
	}


	/**
	 * 
	 * 맵타입 NULL 이나 공백 값 검증 유틸리티 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param paramMaps
	 * @return boolean
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	@Override
	public boolean nullEmptyChkValidate(Object value) {
		
		// 1. 기본 null 체크
	    if (value == null) {
	        return false;
	    }

	    // 2. String 타입: 공백 체크
	    if (value instanceof String) {
	        return !((String) value).trim().isEmpty();
	    }

	    // 3. Map 타입: 내부 Value들을 하나하나 재귀적으로 검사
	    if (value instanceof Map) {
	        Map<?, ?> map = (Map<?, ?>) value;
	        if (map.isEmpty()) return false;
	        
	        for (Object entryValue : map.values()) {
	            // 이 부분이 포인트! 내부 값을 다시 이 메서드로 검사합니다.
	            if (!this.nullEmptyChkValidate(entryValue)) {
	                return false; 
	            }
	        }
	        return true;
	    }

	    // 4. Collection(List, Set) 타입: 내부 아이템들을 하나하나 재귀적으로 검사
	    if (value instanceof Collection) {
	        Collection<?> col = (Collection<?>) value;
	        if (col.isEmpty()) return false;
	        
	        for (Object item : col) {
	            // 리스트 안의 값도 공백이나 null이 있는지 검사
	            if (!this.nullEmptyChkValidate(item)) {
	                return false;
	            }
	        }
	        return true;
	    }

	    // 5. 그 외 일반 객체(DTO 등)는 위에서 null 체크를 통과했으므로 true
	    return true;
	}
}