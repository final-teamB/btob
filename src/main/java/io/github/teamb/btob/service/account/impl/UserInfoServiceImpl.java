package io.github.teamb.btob.service.account.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.account.CompanyInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.mapper.account.UserInfoMapper;
import io.github.teamb.btob.security.PasswordEncryptor;
import io.github.teamb.btob.service.account.UserInfoService;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // private final 생성자를 만들어준다
@Transactional
public class UserInfoServiceImpl implements UserInfoService{
	
	private final UserInfoMapper userInfoMapper;
	private final PasswordEncryptor passwordEncryptor;
	private final CommonService commonService;
	private final LoginUserProvider loginUserProvider;
	
	/**
	 * 
	 * 회원가입
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param userInfoDTO
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	@Override
	public Integer registerUserInfo(UserInfoRegisterRequestDTO userInfoRegisterRequestDTO) throws Exception{
		
		if (! commonService.nullEmptyChkValidate(userInfoRegisterRequestDTO) ) {
			
			throw new Exception("파라미터 오류가 발생하였습니다.");
		}
		
		UserInfoDTO userInfoDTO = userInfoRegisterRequestDTO.getInsertUserInfo();
		CompanyInfoDTO companyInfoDTO = userInfoRegisterRequestDTO.getInsertCompanyInfo();
		
		// ========여기서 회사코드를 생성로직=======
		String compyNm = userInfoDTO.getCompanyName();
		String companyCode = generateCompanyCode(compyNm);
		
		// 세팅
		userInfoDTO.setCompanyCd(companyCode);
		companyInfoDTO.setCompanyCd(companyCode);
		// ===== 생성로직 종료 ========
		
		// 1. 비밀번호 암호화 후 저장 처리
		userInfoDTO.setPassword(
				passwordEncryptor.encrypt(userInfoDTO.getPassword()) 
				);
		
		// 2. 이메일 암호화 후 저장 처리
		userInfoDTO.setEmail(
				passwordEncryptor.encrypt(userInfoDTO.getEmail())
				);
		
		int result = userInfoMapper.insertUser(userInfoDTO);
		
		if ( result > 0 ) {
			
			result = userInfoMapper.insertCompany(companyInfoDTO);
			
			if ( result < 1) {
				throw new Exception("회사 정보 등록에 실패하였습니다.");
			}
		} else {
			throw new Exception("사용자 정보 등록에 실패하였습니다.");
		}
		
		return result = 0;
		
	}
	
	/**
	 * 
	 * 회사 코드 생성 메서드
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param companyName
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	private String generateCompanyCode(String companyName) {

	    if (companyName == null || companyName.isBlank()) {
	        throw new IllegalArgumentException("회사명이 유효하지 않습니다.");
	    }

	    // 1. 법인 표현 제거
	    String cleaned = companyName
	            .replaceAll("\\(주\\)|㈜|주식회사", "")
	            .trim();

	    // 2. 영문만 추출
	    String englishOnly = cleaned.replaceAll("[^A-Za-z]", "");

	    String shortCode;

	    if (!englishOnly.isBlank()) {
	        // 영어가 있는 경우
	        shortCode = englishOnly.toUpperCase();
	    } else {
	        // 한글만 있는 경우 → 초성 추출
	        shortCode = extractInitialConsonants(cleaned);
	    }

	    // 3글자 보장
	    if (shortCode.length() >= 3) {
	        shortCode = shortCode.substring(0, 3);
	    } else {
	        shortCode = String.format("%-3s", shortCode).replace(" ", "X");
	    }

	    // 3. 현재 시간
	    String time = LocalDateTime.now()
	            .format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

	    return time + "-" + shortCode;
	}
	
	/**
	 * 
	 * 회사코드 생성 - 한글 초성 추출 유틸리티
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param text
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	private String extractInitialConsonants(String text) {

	    StringBuilder sb = new StringBuilder();

	    // 한글 초성 매핑 (19개)
	    char[] initials = {
	            'G','G','N','D','D','R','M','B','B',
	            'S','S','O','J','J','C','K','T','P','H'
	    };

	    for (char ch : text.toCharArray()) {

	        // 한글 유니코드 범위
	        if (ch >= 0xAC00 && ch <= 0xD7A3) {

	            int unicode = ch - 0xAC00;
	            int initialIndex = unicode / (21 * 28);

	            sb.append(initials[initialIndex]);
	        }
	    }

	    return sb.toString();
	}

	/**
	 * 
	 * 비밀번호 수정
	 * @author GD
	 * @since 2026. 2. 20.
	 * @param userInfoDTO
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 20.  GD       최초 생성
	 */
	@Override
	public Integer modifyUserPassword( String previousPassword, String newPassword) throws Exception {
		
		// 로그인 사용자
		String loginUserId = "";
		Integer loginUserNo = 0;
		
		if (! commonService.nullEmptyChkValidate(loginUserProvider.getLoginUserId()) ) {
			
			throw new Exception("로그인 사용자가 확인되지 않습니다.");
		} else {
			loginUserId = loginUserProvider.getLoginUserId();
			loginUserNo = loginUserProvider.getLoginUserNo();
		}
		
		// 비밀번호는 암호화 되어야한다.
		UserInfoDTO updto = new UserInfoDTO();
		updto.setPreviousPassword(passwordEncryptor.encrypt(previousPassword));
		updto.setNewPassword(passwordEncryptor.encrypt(newPassword));
		updto.setUpdId(loginUserId);
		updto.setUserId(loginUserId);
		updto.setUserNo(loginUserNo);
		
		if (! commonService.nullEmptyChkValidate(updto) ) {
			
			throw new Exception("파라미터 오류가 발생하였습니다.");
		}
		
		int result = userInfoMapper.updateUserPassword(updto);
		
		if ( result < 1 ) {
			throw new Exception("비밀번호 변경에 실패하였습니다.");
		}
		
		return result;
	}

	
	@Override
	public Integer modifyUserInfo(UserInfoModifyRequestDTO userInfoModifyRequestDTO) throws Exception {

		// 로그인 사용자
		String loginUserId = "";
		Integer loginUserNo = 0;
		
		if (! commonService.nullEmptyChkValidate(loginUserProvider.getLoginUserId()) ) {
			
			throw new Exception("로그인 사용자가 확인되지 않습니다.");
		} else {
			loginUserId = loginUserProvider.getLoginUserId();
			loginUserNo = loginUserProvider.getLoginUserNo();
		}
		
		UserInfoDTO updateUser;
		CompanyInfoDTO updateCompany;
		
		if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateUserInfo())) {
			throw new Exception("파라미터 오류가 발생하였습니다.");
		} else {
			updateUser = userInfoModifyRequestDTO.getUpdateUserInfo();
			
			// 개인정보 수정 시 체크
			// 만약 타입을 변경한다고 했을 때
			// 사원 -> 마스터 권한 요청하는 경우
			// 마스터가 있는지 없는지 확인
			// 마스터 -> 사원 권한으로 요청하는 경우
			String userType = updateUser.getUserType();
			
			UserInfoDTO chkParam = userInfoMapper.selectUserById(loginUserId);
			
			// 일반 사원이 마스터 권한 요청 하는 경우
			if (chkParam.getUserType().equals("USERS")) {
				
				// 현재 대표자가 공석인 경우 신청 가능
				if (chkParam.getIsRepresentative().equals("N")) {
					
				// 대표자가 있으면 신청 불가
				} else {
					throw new Exception("요청이 불가능한 권한이 포함되어있습니다.");
				}
			}
			
			
			
		}
		
		if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateCompanyInfo())) {
			throw new Exception("파라미터 오류가 발생하였습니다.");
		} else {
			updateCompany = userInfoModifyRequestDTO.getUpdateCompanyInfo();
		}
		
		
		return null;
	}
	
}
