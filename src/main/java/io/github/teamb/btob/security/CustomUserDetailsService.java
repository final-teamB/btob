package io.github.teamb.btob.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.account.LoginValidateDTO;
import io.github.teamb.btob.mapper.account.LoginMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 
 * 사용자 로그인 검증 체크 부분
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

	private final LoginMapper loginMapper;
	
	// 스프링 시큐리티 로그인 연동
    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

        log.info("로그인 시도 유저 ID: {}", userId);

        // 사용자
        LoginValidateDTO loginValidateDTO = loginMapper.findLoginValidationUser(userId);

        if ( loginValidateDTO == null ) {

            log.warn("존재하지 않는 사용자 접근 시도: {}", userId);

            // 시큐리티 전용 exception 같음
            throw new UsernameNotFoundException("해당 사용자가 존재하지 않습니다.");
        }

        // Required type: UserDetails
        // 사용자 정보 조회 시 있을 경우
        return new CustomUserDetails(loginValidateDTO);
    }
}
