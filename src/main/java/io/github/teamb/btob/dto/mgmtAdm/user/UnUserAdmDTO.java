package io.github.teamb.btob.dto.mgmtAdm.user;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 사용자 미사용 처리 DTO
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Data
public class UnUserAdmDTO {
	
	private Integer userNo;			// 식별자
	private String accStatus;		// 계정상태
	private LocalDateTime updDtime; // 수정일자
	private String updId;		// 수정자
	private String useYn;		// 사용여부
}
