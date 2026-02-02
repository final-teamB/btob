package io.github.teamb.btob.dto.mgmtAdm.est;

import lombok.Data;

/**
 * 
 * 견적서 미사용 처리 DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class UnUseEstDTO {

	private Integer estId;			// 견적서 기본 식별자
	private Integer estDocID;		// 견적서 세부 식별자
}
