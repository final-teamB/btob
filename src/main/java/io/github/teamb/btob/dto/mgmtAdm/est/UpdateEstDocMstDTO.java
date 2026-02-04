package io.github.teamb.btob.dto.mgmtAdm.est;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 견적서 문서 수정 DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class UpdateEstDocMstDTO {
	
	private Integer estDocId;		// 견적서 식별자
	private Integer requestUserId;	// 요청자
	private String ctrtNm;			// 계약명
	private String estdtMemo;		// 요청 세부내용
	
	// 작성중일때만 수정가능 et001
	private String etpSttsCd;		// 견적상태코드
	// 유효 기한 연장 요청 시	 ( 최대 7일 연장 가능 )
	private LocalDateTime expireDtime;	// 견적 유효 기한
}
