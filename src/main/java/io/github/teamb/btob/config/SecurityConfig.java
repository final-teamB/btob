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
                
            	// 주석했더니 / 루트 안됬음 그냥 명시적으로 선언처리함
            	.requestMatchers("/", "/loginProc" , "/css/**", "/js/**", "/error", "/favicon.ico").permitAll()
                
            	/* =============== JM PART =============== */
            	// 관리자 영역
            	.requestMatchers("/admin/company/**").hasRole("ADMIN")								// 개발도중폐기 관리자 회사관리
                .requestMatchers("/admin/etp/**").hasRole("ADMIN")									// 관리자 주문관리
                .requestMatchers("/admin/etphist/**").hasRole("ADMIN")								// 관리자 히스토리 이력.
                .requestMatchers("/admin/products/**").hasRole("ADMIN")								// 관리자 상품관리
                
                // 내 정보 페이지
                .requestMatchers("/account/mypage/**").hasAnyRole("ADMIN", "MASTER", "USER")			// 가입한 사용자만 접근 가능 내정보페이지
                .requestMatchers("/account/api/modify").hasAnyRole("ADMIN", "MASTER", "USER")			// 가입한 사용자만 접근 가능 내정보수정기능
                .requestMatchers("/account/api/updatePassword").hasAnyRole("ADMIN", "MASTER", "USER")	// 가입한 사용자만 접근 가능 내정보비밀번호변경
                .requestMatchers("/account/api/re-apply").hasAnyRole("ADMIN", "MASTER", "USER")			// 가입한 사용자만 접근 가능 내정보에서권한재신청
                
                // 메인페이지
                .requestMatchers("/main").hasAnyRole("ADMIN", "MASTER", "USER")							// 가입한 사용자만 접근 가능 메인페이지
                .requestMatchers("/api/external/exchange-rate").hasAnyRole("ADMIN", "MASTER", "USER")	// 가입한 사용자만 접근 가능 메인페이지 환율체크
                .requestMatchers("/api/external/oil-news").hasAnyRole("ADMIN", "MASTER", "USER")		// 가입한 사용자만 접근 가능 메인페이지 오일뉴스
                
                // 일반 사용자 상품 페이지
                .requestMatchers("/usr/productView/**").hasAnyRole("ADMIN", "MASTER", "USER")			// 가입한 사용자만 접근 가능 상품 페이지
                
                // API 영역
                .requestMatchers("/api/file/**").hasAnyRole("ADMIN", "MASTER", "USER")					// 첨부파일
                /* =============== JM PART END =============== */
                
                /* =============== JG PART =============== */
                
                .requestMatchers("/trade/**").hasRole("MASTER")
                .requestMatchers("/users/**").hasRole("MASTER")
                .requestMatchers("/payment/**").hasAnyRole("ADMIN", "MASTER", "USER")
                .requestMatchers("/order/**").hasAnyRole("ADMIN", "MASTER", "USER")
                .requestMatchers("/document/**").hasAnyRole("ADMIN", "MASTER", "USER")
                .requestMatchers("/cart/**").hasAnyRole("ADMIN", "MASTER", "USER")
                
                /* =============== JG PART END =============== */
                
                /* =============== SH PART =============== */
                .requestMatchers("/notice/write", "/notice/edit/**", "/notice/update", "/notice/delete/**").hasRole("ADMIN")
                .requestMatchers("/admin/delivery/**").hasRole("ADMIN")
                .requestMatchers("/admin/stats/**").hasRole("ADMIN")
                .requestMatchers("/support/admin/**").hasRole("ADMIN")
                .requestMatchers("/admin/user/**").hasRole("ADMIN")
                .requestMatchers("/users/**", "/trade/**").hasRole("MASTER")
                
                .requestMatchers("/index/**").hasAnyRole("ADMIN", "MASTER", "USER")				// 테스트 페이지?
                /* =============== SH PART END =============== */
                .anyRequest().permitAll()
            )
            
            // 예외 처리 설정: 인증되지 않은 사용자가 접근 시 리다이렉트
            .exceptionHandling(exception -> exception
                    .authenticationEntryPoint((request, response, authException) -> {
                        // 로그인하지 않은 사용자가 권한이 필요한 페이지 접근 시 /home/index로 보냄
                        response.sendRedirect("/home/index");
                    })
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
                    .loginPage("/home/index")
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