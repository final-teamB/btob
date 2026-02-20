package io.github.teamb.btob.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import io.github.teamb.btob.mapper.account.LoginMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	private final LoginMapper loginMapper;
	
	/**
	 * 
	 * 인증/검증 성공 시
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param request
	 * @param response
	 * @param authentication
	 * @throws IOException
	 * @throws ServletException
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, 
			HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
			// 로그인 시도한 아이디
	        String userId = authentication.getName();
	
	        // 로그인 성공하면 기존 누적 비밀번호 오류 초기화
	        loginMapper.resetLoginFailCnt(userId);
	        
	        //AuthenticationSuccessHandler.super.onAuthenticationSuccess(request, response, chain, authentication);
	        response.sendRedirect("/main");
		}
}
