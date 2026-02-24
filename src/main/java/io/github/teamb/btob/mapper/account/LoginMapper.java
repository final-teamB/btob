package io.github.teamb.btob.mapper.account;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.account.LoginValidateDTO;

@Mapper
public interface LoginMapper {
	
	//  로그인 시도 사용자 검증 항목
    LoginValidateDTO findLoginValidationUser(String userId);

    // CustomAuthenticationSuccessHandler 에서 사용
    // 로그인 성공 시 마다 누적 실패 횟수 초기화
    Integer resetLoginFailCnt(String userId);
    
    // CustomAuthenticationFailureHandler 에서 사용
    // 로그인 실패 시 횟수 증가
    Integer increaseLoginFailCntAndLockMemberId(String userId);

    // 계정 장금 처리
    Integer lockMemberId(String userId);
    
    // 계정 잠금 해제 처리
    Integer unlockMemberId(String userId);
}
