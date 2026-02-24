package io.github.teamb.btob.mapper.account;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.account.CompanyInfoDTO;
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
    
}
