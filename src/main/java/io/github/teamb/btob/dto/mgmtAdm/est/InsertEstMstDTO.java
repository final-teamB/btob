package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;

/**
 * 
 * 견적서 등록 ( 4 )
 * 견적서 메인 등록 DTO
 * 관련 테이블 == TB_EST_MST
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Data
public class InsertEstMstDTO {

	private Integer estDocId;		// 견적서 문서 식별번호
	private String etpSttsCd;		// 견적서 상태 코드
}
