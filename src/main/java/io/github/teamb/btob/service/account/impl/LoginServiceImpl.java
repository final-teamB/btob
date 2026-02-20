package io.github.teamb.btob.service.account.impl;

import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.mapper.account.LoginMapper;
import io.github.teamb.btob.security.CustomUserDetails;
import io.github.teamb.btob.security.CustomUserDetailsService;
import io.github.teamb.btob.security.PasswordEncryptor;
import io.github.teamb.btob.service.account.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class LoginServiceImpl implements LoginService {
	
		private final CustomUserDetailsService customUserDetailsService;
	    private final PasswordEncryptor passwordEncryptor;
	    private final LoginMapper loginMapper;
	
	    @Override
		public void login(String userId, String password) {
	
	    	log.info("로그인 시도 Impl 실행: {}", userId);
	
	        // 데이터 로드
	        CustomUserDetails userDetails = (CustomUserDetails) customUserDetailsService.loadUserByUsername(userId);
	        
	        // 상태 검증
	        validateAccountStatus(userDetails);
	
	        // 비밀번호 매칭
	        if (!passwordEncryptor.matches(password, userDetails.getPassword())) {
	
	        	processLoginFailure(userId);
	            throw new BadCredentialsException("아이디 또는 비밀번호가 일치하지 않습니다.");
	        }
	
	        // 4. 성공 시 처리
	        loginMapper.resetLoginFailCnt(userId);
		}
    
	    private void validateAccountStatus(CustomUserDetails userDetails) {
	
	        if (!userDetails.isEnabled()) {
	            throw new DisabledException("비활성화된 계정입니다.");
	        }
	        if (!userDetails.isAccountNonLocked()) {
	            throw new LockedException("계정이 잠겨있습니다.");
	        }
	        if (!userDetails.isAccountNonExpired()) {
	            throw new AccountExpiredException("만료된 계정입니다.");
	        }
	        if (!userDetails.isCredentialsNonExpired()) {
	            throw new CredentialsExpiredException("비밀번호가 만료되었습니다.");
	        }
	    }
	
	    private void processLoginFailure(String userId) {
	
	        loginMapper.increaseLoginFailCntAndLockMemberId(userId);
	    }

}
