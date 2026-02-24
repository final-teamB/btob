package io.github.teamb.btob.dto.account;

import lombok.Data;

/**
 * 
 * 아이디/패스워드 찾기 요청용 DTO
 * @author GD
 * @since 2026. 2. 24.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 24.  GD       최초 생성
 */
@Data
public class FindRequestDTO {
	
	private String userName;
    private String email;
    private String userId;     // 비밀번호 찾기 시에만 사용
}
