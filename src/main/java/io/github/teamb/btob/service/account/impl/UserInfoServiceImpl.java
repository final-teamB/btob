package io.github.teamb.btob.service.account.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.account.CompanyInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.mapper.account.UserInfoMapper;
import io.github.teamb.btob.security.PasswordEncryptor;
import io.github.teamb.btob.service.account.UserInfoService;
import io.github.teamb.btob.service.common.CommonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
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
		
		if (! commonService.nullEmptyChkValidate(userInfoRegisterRequestDTO.getInsertUserInfo()) ) {
			
			throw new Exception("파라미터 오류가 발생하였습니다.");
		}
		
		UserInfoDTO userInfoDTO = userInfoRegisterRequestDTO.getInsertUserInfo();
		CompanyInfoDTO companyInfoDTO;
		
		// 1. 비밀번호 암호화 후 저장 처리
		userInfoDTO.setPassword(
				passwordEncryptor.encrypt(userInfoDTO.getPassword()) 
				);
		
		// 2. 이메일 암호화 후 저장 처리 -- 미협의로 주석
		/*
		userInfoDTO.setEmail(
				passwordEncryptor.encrypt(userInfoDTO.getEmail())
				);
		*/
		
		// 3. 기타 세팅
		userInfoDTO.setIsRepresentative("Y");		// 대표는 무조건 일단 있다고 세팅
		userInfoDTO.setAccStatus("ACTIVE");			// 계정 상태 온
		userInfoDTO.setAppStatus("PENDING");		// 계정 권한 상태는 승인 대기로
		userInfoDTO.setRegId(userInfoDTO.getUserId());		// 등록자 ID 세팅
		
		int result = 0;
		
		// 대표 사용자 가입인 경우
		if (userInfoDTO.getUserType().equals("MASTER")) {
			
			if ( ! commonService.nullEmptyChkValidate(userInfoRegisterRequestDTO.getInsertCompanyInfo()) ) {
				throw new Exception("파라미터 오류가 발생하였습니다.");
			}
			
			companyInfoDTO = userInfoRegisterRequestDTO.getInsertCompanyInfo();
			
			// ========여기서 회사코드를 생성로직=======
			String compyNm = companyInfoDTO.getCompanyName();
			String companyCode = generateCompanyCode(compyNm);
			
			// 세팅
			userInfoDTO.setCompanyCd(companyCode);
			companyInfoDTO.setCompanyCd(companyCode);
			// ===== 생성로직 종료 ========
			
			companyInfoDTO.setMasterId(userInfoDTO.getUserId());
			companyInfoDTO.setRegId(userInfoDTO.getUserId());
			
			// 대표 사용자 인경우 회사정보부터 넣어줘야함 
			result = userInfoMapper.insertCompany(companyInfoDTO);
			
			if ( result < 1) {
				throw new Exception("회사 정보 등록에 실패하였습니다.");
			}
			
		} else if ("USER".equals(userInfoDTO.getUserType()) && 
		        "ETC".equals(userInfoDTO.getCompanyCd()) ) {
			
			userInfoDTO.setIsRepresentative("N");
		}
		
		result = userInfoMapper.insertUser(userInfoDTO);
		
		if ( result < 0 ) {
			throw new Exception("사용자 정보 등록에 실패하였습니다.");
		} 

		return result;
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
		
		// 2. 새 비밀번호와 기존 비밀번호 동일 여부 체크 (문자열 평문 비교)
	    // 이 체크를 가장 먼저 해야 불필요한 DB 조회를 줄일 수 있습니다.
	    if (previousPassword.equals(newPassword)) {
	        throw new Exception("현재 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
	    }
	    
	    // 3. DB에서 현재 암호화된 비밀번호 가져오기
	    UserInfoDTO user = userInfoMapper.selectUserById(loginUserId);
	    if (user == null) {
	        throw new Exception("사용자 정보를 확인할 수 없습니다.");
	    }
	    String currentEncryptedPassword = user.getPassword();

	    // 4. 현재 비밀번호 일치 여부 체크 (PasswordEncryptor.matches 사용)
	    // encrypt() 결과끼리 비교하는 것이 아니라 평문과 암호문을 matches로 비교해야 합니다.
	    if (!passwordEncryptor.matches(previousPassword, currentEncryptedPassword)) {
	        throw new Exception("현재 비밀번호가 일치하지 않습니다.");
	    }
		
		// 비밀번호는 암호화 되어야한다.
		UserInfoDTO updto = new UserInfoDTO();
		updto.setPreviousPassword(currentEncryptedPassword);
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

	/**
	 * 
	 * 마이페이지 - 개인정보 수정
	 * @author GD
	 * @since 2026. 2. 23.
	 * @param userInfoModifyRequestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 23.  GD       최초 생성
	 */
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
		int result = 0;
		
		// 사용자테이블 변경 DTO 파라미터 검증
		if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateUserInfo())) {
			throw new Exception("파라미터 오류가 발생하였습니다.");
		} else {
			updateUser = userInfoModifyRequestDTO.getUpdateUserInfo();
			// 업데이트 사용자
			updateUser.setUpdId(loginUserId);
			updateUser.setUserId(loginUserId);
			updateUser.setUserNo(loginUserNo);
			
			// 개인정보 수정 시 체크
			// 만약 타입을 변경한다고 했을 때
			// 사원 -> 마스터 권한 요청하는 경우
			// 마스터가 있는지 없는지 확인
			// 마스터 -> 사원 권한으로 요청하는 경우
			String userType = updateUser.getUserType();
			
			UserInfoDTO chkParam = userInfoMapper.selectUserById(loginUserId);
			
			///////////////////// 권한이 일반인 경우 ////////////////////////
			
			// 개인정보 수정 시 추가로 일반 사원이 마스터 권한 요청 하는 경우
			// 현재 권한이 유저타입이고 변경 요청이 마스터 권한
			if (chkParam.getUserType().equals("USER") && 
					userType.equals("MASTER")) {
				
				// 현재 대표자가 공석인 경우 신청 가능
				if (chkParam.getIsRepresentative().equals("N")) {
					
					result = userInfoMapper.updateUserInfo(updateUser);
					
					if (result < 1) {
						throw new Exception("일반 사원 정보 수정 시 오류가 발생했습니다.");
					}
				// 대표자가 있으면 신청 불가
				} else {
					throw new Exception("요청이 불가능한 권한이 포함되어있습니다.");
				}
			
			// 개인정보 수정 시 권한 요청이 없는 경우	
			} else {
				
				result = userInfoMapper.updateUserInfo(updateUser);
				
				log.info("사용자 일반 사원 사용자 테이블 업데이트 result : " +  result);
			}
			
			///////////////////// 권한이 마스터인 경우 ////////////////////////
			
			// 마스터 -> 사원 권한으로 요청하는 경우
			// 마스터 사용자는 1명 양도할 사용자를 선택해야한다.
			// 현재 권한이 유저타입이고 변경 요청이 마스터 권한
			if (chkParam.getUserType().equals("MASTER") && 
					userType.equals("USER")) {
				
				// 양도할 사용자 확인
				// null 이면 false로 떨어집니다.
				if ( !(commonService.nullEmptyChkValidate(updateUser.getAssignee())) ) {
					throw new Exception("양도 받을 사용자가 없습니다.");
				}
				
				// 양도할 사용자가 있다면
				result = userInfoMapper.updateUserInfo(chkParam);
				
				// 업데이트에 성공했다면 회사테이블의 마스터 ID도 변경해야합니다.
				if ( result > 0 ) {
					
					if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateCompanyInfo())) {
						throw new Exception("회사 파라미터 오류가 발생하였습니다.");
					}
					
					CompanyInfoDTO companyUpdate = userInfoModifyRequestDTO.getUpdateCompanyInfo();
					// 업데이트 사용자
					companyUpdate.setUpdId(loginUserId);
					
					// 양도자에게 마스터 권한 부여
					companyUpdate.setMasterId(updateUser.getAssignee());
					// 회사테이블 업데이트
					result = userInfoMapper.updateCompanyInfo(companyUpdate);
					
					log.info("사용자 마스터 회사테이블 업데이트 result : " +  result);
				}
			}
			///////////////////// 그 밖인 경우 ////////////////////////

			// 업데이트
			result = userInfoMapper.updateUserInfo(updateUser);
			
			
			// null 이 아니면 업데이트
			// 회사정보 업데이트 안할수도 있어서 throw 안함
			if (commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateCompanyInfo())) {
				
				updateCompany = userInfoModifyRequestDTO.getUpdateCompanyInfo();
				updateCompany.setUpdId(loginUserId);
				
				userInfoMapper.updateCompanyInfo(updateCompany);
			}
		}
		
		return result;
	}
	
	
	/**
	 * 
	 * 셀렉박스 리스트 추출
	 * @author GD
	 * @since 2026. 2. 23.
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 23.  GD       최초 생성
	 */
	@Override
	public Map<String, List<SelectBoxVO>> registerCompanySelectBoxList() {
	    
	    Map<String, List<SelectBoxVO>> resultMap = new HashMap<>();
	    
	    // 공통 설정 (테이블명, 컬럼명 등)
	    String table = "COMM_TBL";
	    String codeCol = "COMM_NO";
	    String nameCol = "COMM_NAME";
	    String targetCol = "PARAM_VALUE"; 

	    // 1. 사용자 권한 ( USER_TYPE )
	    resultMap.put("userTypeList", getSelectBox(table, codeCol, nameCol, targetCol, "USER_TYPE"));

	    // 2. 회사 셀렉박스 ( COMPANY )
	    resultMap.put("companyList", getSelectBox("TB_COMPANIES", "company_cd", "company_name", "", ""));

	    return resultMap;
	}

	/**
	 * 
	 * 셀렉박스 파라미터 세팅을 위한 내부 헬퍼 메서드 (리턴타입 VO로 수정)
	 * @author GD
	 * @since 2026. 2. 23.
	 * @param table
	 * @param cd
	 * @param nm
	 * @param target
	 * @param where
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 6.  GD       최초 생성
	 */
	private List<SelectBoxVO> getSelectBox(String table, String cd, String nm, String target, String where) {
	    
	    SelectBoxListDTO dto = new SelectBoxListDTO();
	    dto.setCommonTable(table);
	    dto.setCommNo(cd);
	    dto.setCommName(nm);
	    dto.setTargetCols(target);
	    dto.setWhereCols(where);
	    
	    // 이제 Generic 파라미터(class)를 넘길 필요 없이 깔끔하게 호출 가능합니다.
	    return commonService.getSelectBoxList(dto);
	}

	/**
	 * 
	 * 사용자 정보 가져오기
	 * @author GD
	 * @since 2026. 2. 23.
	 * @param userId
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 23.  GD       최초 생성
	 */
	@Override
	public UserInfoDTO getUserInfoById(String userId) {
		
	    return userInfoMapper.selectUserById(userId);
	}
}
