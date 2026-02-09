package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

/**
 * 
 * 동적 쿼리 사용 시 적용 테이블, 컬럼, 식별자컬럼 확인
 * 관련테이블 TB_ETP_TARGET_TABLE
 * 관련시스템하나당 업데이트 대상 테이블은 하나로 규정됩니다.
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class EtpDynamicParamsDTO {
	
	private String targetTable;				// 업데이트 대상 테이블
	private String targetStatusCol;			// 업데이트 대상 상태 컬럼
	private String targetPkCol;				// 업데이트 대상 테이블 식별자 컬럼
}