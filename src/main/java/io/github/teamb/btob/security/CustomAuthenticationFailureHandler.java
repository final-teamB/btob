package io.github.teamb.btob.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import io.github.teamb.btob.dto.account.LoginValidateDTO;
import io.github.teamb.btob.mapper.account.LoginMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

	
	private final LoginMapper loginMapper;
	
	/**
	 * 
	 * 인증/검증 실패 시
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param request
	 * @param response
	 * @param exception
	 * @throws IOException
	 * @throws ServletException
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, 
										HttpServletResponse response,
										AuthenticationException exception) throws IOException, ServletException {
		
		/*
			DaoAuthenticationProvider가 내부적으로 처리합니다.
	        사용자가 로그인을 시도합니다.
	        UserDetailsService가 DB에서 사용자를 찾아 UserDetails를 반환합니다.
	        시큐리티가 내부적으로 UserDetails.getPassword()와 입력받은 비번을 비교합니다.
	        비번이 틀리면? 시큐리티는 BadCredentialsException을 던지고 인증을 중단합니다.
	        이때 제어권이 **AuthenticationFailureHandler**로 넘어옵니다.
        */
        String userId = request.getParameter("userId");
        String errorMessage = "사용자 ID나 비밀번호를 잘못 입력하였습니다.";


        // 계정 잠금 확인
        if (userId != null && !userId.isEmpty()) {

            // 1. 비밀번호가 틀린 경우
            if (exception instanceof BadCredentialsException) {
            	
            	loginMapper.increaseLoginFailCntAndLockMemberId(userId);

                // 실패 횟수 재조회 시 null 체크 추가
                LoginValidateDTO userLoginCntChk = loginMapper.findLoginValidationUser(userId); 

                if (userLoginCntChk != null && userLoginCntChk.getUserLoginFailCnt() >= 5) {

                    loginMapper.lockMemberId(userId);
                    errorMessage = "비밀번호 5회 이상 누적 실패로 계정이 잠금되었습니다.";
                } else {

                    errorMessage = "비밀번호가 올바르지 않습니다. (실패횟수: " + (userLoginCntChk != null ? userLoginCntChk.getUserLoginFailCnt() : 0) + ")";
                }
            }
            
            // isAccountNonLocked()가 false일 때
            // 2. 이미 계정이 잠긴 상태에서 로그인을 시도한 경우 (UserDetails에서 false 반환 시)
            else if (exception instanceof LockedException) {

                errorMessage = "비밀번호 5회 이상 누적 실패로 계정이 잠금 되어있습니다.";
            }
        }

        // 에러 메시지를 인코딩하여 전달
        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        response.sendRedirect("/login?error=true&exception=" + encodedMessage);
	}
}
