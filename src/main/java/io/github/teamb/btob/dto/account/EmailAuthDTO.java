package io.github.teamb.btob.dto.account;

import lombok.Data;

/**
 * 
 * 이메일 인증번호 검증용 DTO
 * @author GD
 * @since 2026. 2. 24.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 24.  GD       최초 생성
 */
@Data
public class EmailAuthDTO {

	private String userName;
	private String email;
    private String authNum;    // 발급된 인증번호
    private String type;       // ID(아이디찾기), PW(비번찾기) 구분
    private String userId;   // PW 찾기용
}
