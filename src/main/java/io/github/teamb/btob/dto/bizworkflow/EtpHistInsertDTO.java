package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;

/**
 * 
 * 히스토리 이력 추가 DTO
 * 관련테이블 = TB_ETP_HIST
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class EtpHistInsertDTO {

	private Integer refId;					// 식별자
	private String requestEtpStatus;		// 변경요청한 상태코드
	private Integer apprUserNo;			// 승인자
	private Integer requestUserNo;		// 요청자
	private String rejtRsn;				// 사유 (반려시)
	private String userId;
}


