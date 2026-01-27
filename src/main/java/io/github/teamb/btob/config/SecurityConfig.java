package io.github.teamb.btob.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public PasswordEncoder passwordEncoder() {
	    return new BCryptPasswordEncoder();
	}

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // 1. 모든 정적 자원과 에러 페이지, 파비콘을 완전히 개방
                .requestMatchers("/login", "/register", "/css/**", "/js/**", "/error", "/favicon.ico", "jjjtest").permitAll()
                // 2. 나머지 모든 요청 permitAll()로 설정
                .anyRequest().permitAll()
            )
            // SecurityConfig.java - formLogin
            .formLogin(form -> form
            	    .loginPage("/login")
            	    .usernameParameter("email")
            	    .passwordParameter("password")
            	    .defaultSuccessUrl("/main", true) // 반드시 절대 경로인 /main 설정
            	    .failureUrl("/login?error=true")
            	    .permitAll()
            );
        return http.build();
    }
}
