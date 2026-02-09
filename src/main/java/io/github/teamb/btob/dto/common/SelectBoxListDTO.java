package io.github.teamb.btob.dto.common;

import lombok.Data;

/**
 * 
 * 셀렉박스 추출 동적 쿼리 DTO
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class SelectBoxListDTO {
	
	private String commonCd;		// 코드
	private String commonNm;		// 코드명
	private String commonTable;		// 서치테이블
	private String targetCols;		// 타겟컬럼
	private String whereCols;		// 조건컬럼
}
