package io.github.teamb.btob.service.account;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.account.FindRequestDTO;
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
    
    // 6. 권한 재신청
    Integer reauthorizationAppStatus(String userId);
    
    // 7. 아이디 찾기
    String processFindId(FindRequestDTO findRequestDTO) throws Exception;
    
    // 8. 비밀번호 찾기
    boolean processResetPassword(UserInfoDTO userInfoDTO) throws Exception;
    
    // 9. 이메일 사용자 체크 시 사용 ( 아이디 쪽 )
    boolean checkUserExists(String userName, String email) throws Exception;
    
    // 9.1 이메일 사용자 밴 체크 시 사용 ( 아이디 쪽 )
    boolean checkUserBanExists(String userName, String email) throws Exception;
    
    // 10. 이메일 사용자 체크 시 사용  ( 비밀번호 쪽 )
    boolean checkUserPwExists(String userName, String userId, String email) throws Exception;
    
    // 10.1 이메일 사용자 밴 체크 시 사용  ( 비밀번호 쪽 )
    boolean checkUserBanPwExists(String userName, String userId, String email) throws Exception;
    
    // 11. 회원가입시 사용자 ID 중복 체크
    boolean userIdDuplicationChk(String userId) throws Exception;
}	
