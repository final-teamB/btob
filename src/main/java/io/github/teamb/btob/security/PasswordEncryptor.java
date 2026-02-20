package io.github.teamb.btob.security;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

/**
 * 
 * 설명
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Component
@RequiredArgsConstructor
public class PasswordEncryptor {
	 
	private final PasswordEncoder passwordEncoder;

		/**
		 * 
		 * 패스워드 인코딩
		 * @author GD
		 * @since 2026. 2. 20.
		 * @param rawPw
		 * @return
		 * 수정일        수정자       수정내용
		 * ----------  --------    ---------------------------
		 * 2026. 2. 20.  GD       최초 생성
		 */
	    public String encrypt(String rawPw) {

	        return passwordEncoder.encode(rawPw);
	    }

	    /**
	     * 
	     * 패스워드 일치 여부 체크 ( 평문 비밀번호, DB에 저장된 암호화 비밀번호 )
	     * @author GD
	     * @since 2026. 2. 20.
	     * @param rawPw
	     * @param encodePw
	     * @return
	     * 수정일        수정자       수정내용
	     * ----------  --------    ---------------------------
	     * 2026. 2. 20.  GD       최초 생성
	     */
	    public boolean matches(String rawPw, String encodePw) {

	        return passwordEncoder.matches(rawPw, encodePw);
	    }
}
