package io.github.teamb.btob.security;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

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
            
            // 1. 비밀번호 불일치 (BadCredentialsException)
            if (exception instanceof BadCredentialsException) {
                try {
                    // DB의 실패 카운트 증가 및 잠금 처리 실행
                    loginMapper.increaseLoginFailCntAndLockMemberId(userId);
                    
                    // 최신 실패 횟수 조회를 위해 DB 다시 읽기
                    LoginValidateDTO userDetails = loginMapper.findLoginValidationUser(userId);
                    
                    if (userDetails != null) {
                        int failCnt = userDetails.getUserLoginFailCnt();
                        if (failCnt >= 5) {
                            errorMessage = "비밀번호 5회 이상 누적 실패로 계정이 잠금되었습니다.";
                        } else {
                            errorMessage = String.format("비밀번호가 올바르지 않습니다. (실패 횟수: %d/5)", failCnt);
                        }
                    }
                } catch (Exception e) {
                    log.error("로그인 실패 처리 중 DB 오류 발생: ", e);
                }
            } 
            // 2. 이미 계정이 잠겨 있는 상태에서 로그인 시도 (LockedException)
            else if (exception instanceof LockedException) {
                errorMessage = "비밀번호 5회 이상 누적 실패로 계정이 잠금되었습니다. 관리자에게 문의하세요.";
            } 
            // 3. 기타 비활성화 상태 (BANNED, DELETED 등)
            else if (exception instanceof DisabledException) {
                errorMessage = "정책에 의해 사용이 제한된 계정입니다. 관리자에게 문의하세요.";
            }
            else {
                errorMessage = exception.getMessage();
            }
        }

        // [중요] AJAX 모달 처리를 위한 JSON 응답 설정
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 에러 상태값 전송

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", false);
        responseData.put("message", errorMessage);

        // JSON 문자열로 변환하여 출력
        ObjectMapper objectMapper = new ObjectMapper();
        response.getWriter().write(objectMapper.writeValueAsString(responseData));
	}
}
