package io.github.teamb.btob.mapper.account;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.account.CompanyInfoDTO;
import io.github.teamb.btob.dto.account.FindRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoDTO;

@Mapper
public interface UserInfoMapper {
	
	// 1.1 회원가입 USER 테이블
    Integer insertUser(UserInfoDTO userInfoDTO);
    
    // 1.2 회원가입 COMPANIES 테이블
    Integer insertCompany(CompanyInfoDTO companyInfoDTO);

    // CustomUserDetailsService 에서 사용
    // 2. 로그인 사용자 확인
    UserInfoDTO selectUserById(String userId);

    // 3. 비밀번호 수정
    Integer updateUserPassword(UserInfoDTO userInfoDTO);
    
    // 4. 개인정보 수정
    Integer updateUserInfo(UserInfoDTO userInfoDTO);
    
    // 5. 회사정보 수정
    Integer updateCompanyInfo(CompanyInfoDTO companyInfoDTO);
    
    // 6. 권한 재신청 처리 시 권한변경 REJECTED -> PENDING 으로 변경 
    Integer updateReAppStatus(UserInfoDTO userInfoDTO);
    
    // 7. 아이디 찾기
    UserInfoDTO findUserIdByUserNmAndEmail(FindRequestDTO findRequestDTO);
    
    // 8. 비밀번호 찾기
    Integer findUserPwByUserNmAndEmailAndUserId(UserInfoDTO userInfoDTO);
    
    // 9. 비밀번호 수정
    Integer updateNewPassword(UserInfoDTO userInfoDTO);
    
    // 10. 사용자 체크 ( 아이디 찾기 쪽 )
    Integer selectUserChk(UserInfoDTO userInfoDTO);
    
    // 10.1. 사용자 벤체크 ( 아이디 찾기 쪽 )
    String selectUserBanChk(UserInfoDTO userInfoDTO);
    
    // 11. 사용자 체크 ( 비밀번호 찾기 쪽 )
    String selectUserChkPw(UserInfoDTO userInfoDTO);
    
    // 11.1. 사용자 벤체크 ( 비밀번호 찾기 쪽 )
    String selectUserPwBanChk(UserInfoDTO userInfoDTO);
    
    // 12. 사용자 ID 중복 체크 ( 회원가입 )
    Integer selectUserIdDuplicateChk(String userId);
    
    // 13. 사용자 이메일 중복 체크 ( 회원 가입 )
    Integer selectEmailDuplicateChk(String email);
}
