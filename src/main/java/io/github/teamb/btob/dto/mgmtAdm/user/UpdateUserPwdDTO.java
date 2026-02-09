package io.github.teamb.btob.dto.mgmtAdm.user;

import lombok.Data;

/**
 * 
 * 사용자 비밀번호 변경 DTO
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Data
public class UpdateUserPwdDTO {
	
	private Integer userNo;
	private String newPasword;
	private String password;
}
