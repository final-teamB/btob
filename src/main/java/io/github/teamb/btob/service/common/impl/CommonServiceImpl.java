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

import java.util.Collections;

import java.util.stream.Collectors;


import com.fasterxml.jackson.databind.ObjectMapper;


@Service
@RequiredArgsConstructor
public class CommonServiceImpl implements CommonService{
	
	private final CommonMapper commonMapper;
	private final ObjectMapper objectMapper = new ObjectMapper();
	

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
	public <T> List<T> getSelectBoxList(SelectBoxListDTO dto, Class<T> targetDTO) {
	
		// 필수 파라미터 검사 
	    if (dto.getCommonCd() == null || 
	    		dto.getCommonNm() == null || 
	    		dto.getCommonTable() == null) {
	    	
	        throw new IllegalArgumentException("필수 파라미터가 없습니다.");
	    }
		
		// DB에서 Map 리스트로 가져옴
        List<Map<String, Object>> selectBoxList = commonMapper.selectBoxList(dto);

        // 데이터가 없는 경우 빈 리스트 반환 (Null 방어)
        if (selectBoxList == null || selectBoxList.isEmpty()) {
            return Collections.emptyList();
        }

        // Map을 원하는 DTO 클래스 타입으로 변환하여 리스트로 반환
        return selectBoxList.stream()
                .map((Map<String, Object> map) -> 
                	objectMapper.convertValue(map, targetDTO))
                .collect(Collectors.toList());
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
