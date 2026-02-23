package io.github.teamb.btob.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import io.github.teamb.btob.security.CustomAuthenticationFailureHandler;
import io.github.teamb.btob.security.CustomAuthenticationSuccessHandler;
import io.github.teamb.btob.security.CustomUserDetailsService;
import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	//private final CustomUserDetailsService customUserDetailsService;
	private final CustomUserDetailsService customUserDetailsService;
    private final PasswordEncoder passwordEncoder;
    // 성공핸들러
    private final CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;
    // 실패핸들러
    private final CustomAuthenticationFailureHandler customAuthenticationFailureHandler;
	
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/loginProc" , "/register", "/css/**", "/js/**", "/error", "/favicon.ico").permitAll()
                .requestMatchers("/", "/account/**", "/main", "/notice", "/notice/**","/admin/products/**").permitAll()
                .requestMatchers("/notice/write", "/notice/edit/**", "/notice/update", "/notice/delete/**").hasRole("ADMIN")
                .requestMatchers("/admin/delivery/**").hasRole("ADMIN")
                .requestMatchers("/admin/stats/**").hasRole("ADMIN")
                .requestMatchers("/support/admin/**").hasRole("ADMIN")
                .requestMatchers("/admin/user/**").hasRole("ADMIN")
                .anyRequest().permitAll()
            )
            // 사용자 인증 설정
            .userDetailsService(customUserDetailsService)
            .sessionManagement(session -> session
            	    .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            	    .sessionFixation().changeSessionId() // 로그인 시 세션 ID를 변경하여 보안 강화 및 세션 고정 방지
            	    .maximumSessions(1)
            	)
            .headers(headers -> headers
                    .frameOptions(frame -> frame.sameOrigin())
             )
            .formLogin(form -> form
                    .loginPage("/login")
                    .loginProcessingUrl("/loginProc")
                    .usernameParameter("userId")
                    .passwordParameter("password")
                    .successHandler(customAuthenticationSuccessHandler)
                    .failureHandler(customAuthenticationFailureHandler)
                    .permitAll()
            )
            .logout(logout -> logout
            		.logoutUrl("/logout") // 로그아웃 처리 URL
            	    .logoutSuccessUrl("/home/index") // 로그아웃 성공 시 이동할 곳
            	    .invalidateHttpSession(true)
            	    .deleteCookies("JSESSIONID") // 쿠키 삭제 추가
            );
        return http.build();
    }
    
    // AuthenticationManager 등록 ( 비밀번호 비교에 필수 )
    // 기존 코드를 유지하고 싶다면, UserDetailsService를 명시적으로 세팅하지 마세요.
	/*
	 * @Bean public AuthenticationManager
	 * authenticationManager(AuthenticationConfiguration configuration) throws
	 * Exception { return configuration.getAuthenticationManager(); }
	 */
}