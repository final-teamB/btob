package io.github.teamb.btob.service.account;

import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;

public interface UserInfoService {
	
	// 1. 회원가입
    Integer registerUserInfo(UserInfoRegisterRequestDTO userInfoRegisterRequestDTO) throws Exception;

    // 2. 비밀번호 수정
    Integer modifyUserPassword(String previousPassword, String newPassword) throws Exception;
    
    // 3. 개인정보 수정
    Integer modifyUserInfo(UserInfoModifyRequestDTO userInfoModifyRequestDTO) throws Exception;
}
