package io.github.teamb.btob.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;


/**
 * 
 *  SecurityConfig와 분리 시킴
 *  SecurityConfig는 보안, 필터 정책 설정
 *  PasswordEncoder는 암호화 정책 설정으로 성격이 다름
 *
 *  후에 BCrypt --> Argon2, PBKDF2 바꾸려면 보안 설정 클래스 수정 필요
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Configuration
public class PasswordConfig {
	
	@Bean
    public PasswordEncoder passwordEncoder() {

        return new BCryptPasswordEncoder();
    }
}
