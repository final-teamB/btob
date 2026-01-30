package io.github.teamb.btob.service.common.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;

import io.github.teamb.btob.mapper.common.CommonMapper;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;

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
	public <T> List<T> getSelectBoxList(String param, Class<T> targetDTO) {
	
		// 스네이크 케이스 대응 (필요 시) 없어도 될 거 같 긴함
		objectMapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
		
		// 1. DB에서 Map 리스트로 가져옴
        List<Map<String, Object>> selectBoxList = commonMapper.selectBoxList(param);

        // 데이터가 없는 경우 빈 리스트 반환 (Null 방어)
        if (selectBoxList == null || selectBoxList.isEmpty()) {
            return Collections.emptyList();
        }

        // 2. Map을 원하는 DTO 클래스 타입으로 변환하여 리스트로 반환
        return selectBoxList.stream()
                .map((Map<String, Object> map) -> objectMapper.convertValue(map, targetDTO))
                .collect(Collectors.toList());
	}


	/**
	 * 
	 * NULL 이나 공백 값 검증 유틸리티 메서드
	 * @author GD
	 * @since 2026. 1. 29.
	 * @param paramMaps
	 * @return boolean
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 29.  GD       최초 생성
	 */
	@Override
	public boolean nullEmptyChkValidate(Map<String, Object> paramMaps) {
		
		if (paramMaps == null || paramMaps.isEmpty()) {
            return false;
        }

        for (Object value : paramMaps.values()) {

        	// 1. null 체크
            if (value == null) {
            	return false;
            }
            
            // 2. String일 경우 공백 체크
            if (value instanceof String && ((String) value).trim().isEmpty()) {
                return false;
            }
            
            // 3. (옵션) List나 다른 컬렉션일 경우 비어있는지 체크 가능
        }
        
        // 전부 성공이면 true
        return true;
	}
}
