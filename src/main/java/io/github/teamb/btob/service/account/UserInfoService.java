package io.github.teamb.btob.service.account;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;

public interface UserInfoService {
	
	// 1. 회원가입
    Integer registerUserInfo(UserInfoRegisterRequestDTO userInfoRegisterRequestDTO) throws Exception;

    // 2. 비밀번호 수정
    Integer modifyUserPassword(String previousPassword, String newPassword) throws Exception;
    
    // 3. 개인정보 수정
    Integer modifyUserInfo(UserInfoModifyRequestDTO userInfoModifyRequestDTO) throws Exception;
    
    // 4. 회사 셀렉박스
    Map<String, List<SelectBoxVO>> registerCompanySelectBoxList();
    
    // 5. 사용자 정보 가져오기
    UserInfoDTO getUserInfoById(String userId);
}
