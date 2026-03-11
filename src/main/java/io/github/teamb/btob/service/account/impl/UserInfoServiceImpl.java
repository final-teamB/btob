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
import io.github.teamb.btob.dto.account.FindRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.compy.UpdateCompyDTO;
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
			
			String companyName = companyInfoDTO.getCompanyName();
			String addrKor = companyInfoDTO.getAddrKor();
			String zipCode = companyInfoDTO.getZipCode();
			String bizNumber = companyInfoDTO.getBizNumber();
			
			CompanyInfoDTO companyDuplicateChk = new CompanyInfoDTO();
			
			companyDuplicateChk.setCompanyName(companyName);
			companyDuplicateChk.setAddrKor(addrKor);
			companyDuplicateChk.setZipCode(zipCode);
			companyDuplicateChk.setBizNumber(bizNumber);
			
			if ( userInfoMapper.selectCompanyDuplicateChk(companyDuplicateChk) > 0 ) {
				throw new Exception("이미 등록된 상호입니다");
			}
			
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
		
		// 2. 파라미터 검증
	    if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateUserInfo())) {
	        throw new Exception("파라미터 오류가 발생하였습니다.");
	    }

	    UserInfoDTO updateUser = userInfoModifyRequestDTO.getUpdateUserInfo();
	    
	    UserInfoDTO currentUser = userInfoMapper.selectUserById(loginUserId);
	    
	    // 입력받은 이메일이 현재 내 이메일과 다를 때만 중복 체크 실행
	    if (!(updateUser.getEmail().equals(currentUser.getEmail()))) {
	    	
	        Integer pmchk = userInfoMapper.selectEmailDuplicateChk(updateUser.getEmail());
	        
	        if (pmchk > 0) {
	            throw new Exception("중복된 이메일은 사용이 불가능합니다.");
	        }
	    }
	    
	    updateUser.setUpdId(loginUserId);
	    updateUser.setUserId(loginUserId);
	    updateUser.setUserNo(loginUserNo);

	    // DB에 저장된 현재 사용자의 실제 정보 조회
	    UserInfoDTO chkParam = userInfoMapper.selectUserById(loginUserId);
	    String currentType = chkParam.getUserType(); // 현재 권한
	    //String requestType = updateUser.getUserType(); // 변경 요청 권한
	    
	    int result = 1;
	    
	    // 마스터 사용자인경우
	    if ( currentType.equals("MASTER") ) {
	    	
	    	userInfoMapper.updateUserInfo(updateUser);
	    	log.info("마스터 사용자 개인 정보 업데이트 완료");
	    	
	    	if (!commonService.nullEmptyChkValidate(userInfoModifyRequestDTO.getUpdateCompanyInfo())) {
		        throw new Exception("파라미터 오류가 발생하였습니다.");
		    }
	    	
	    	CompanyInfoDTO updateCompyDTO = userInfoModifyRequestDTO.getUpdateCompanyInfo();
	    	
	    	if ( loginUserId.equals(updateCompyDTO.getMasterId()) ) {
	    	
	    		updateCompyDTO.setUpdId(loginUserId);
		    	updateCompyDTO.setMasterId(loginUserId);
		    	userInfoMapper.updateCompanyInfo(updateCompyDTO);
	            log.info("마스터 사용자 회사 정보 업데이트 완료");
	    	} else {
	    		throw new Exception("해당 로그인 사용자는 대표 사용자가 아닙니다.");
	    	}
        // 개인 사용자 및 관리자인경우
	    } else if ( currentType.equals("USER") || currentType.equals("ADMIN") ) {
	    	
	    	userInfoMapper.updateUserInfo(updateUser);
	    	log.info("개인 사용자 및 관리자 개인 정보 업데이트 완료");
	    	
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

	/**
	 * 
	 * 권한 재 신청 시 권한 상태 변경
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userId
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public Integer reauthorizationAppStatus(String userId) {
		
		UserInfoDTO reAppUser = new UserInfoDTO();
		reAppUser.setUpdId(userId);
		reAppUser.setUserId(userId);
		
		return userInfoMapper.updateReAppStatus(reAppUser);
	}

	
	/**
	 * 
	 * 아이디 찾기
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param findRequestDTO
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public String processFindId(FindRequestDTO findRequestDTO) throws Exception {
		
		if (! commonService.nullEmptyChkValidate(findRequestDTO) ) {
			
			throw new Exception("파라미터 오류가 발생하였습니다.");
		}
		
		// 아이디 찾기
		UserInfoDTO usr = userInfoMapper.findUserIdByUserNmAndEmail(findRequestDTO);
		
		if (usr == null) {
	        throw new Exception("입력하신 정보와 일치하는 사용자가 없습니다.");
	    }
												
		return "아이디: " + usr.getUserId() + " (가입일: " + usr.getRegDtime() + ")";
	}

	/**
	 * 
	 * 비밀번호 재설정
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userInfoDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean processResetPassword(UserInfoDTO userInfoDTO) throws Exception {
		
		// 1. 파라미터 유효성 검사 
	    if (!commonService.nullEmptyChkValidate(userInfoDTO)) {
	        throw new Exception("입력 정보가 누락되었습니다.");
	    }

	    // 2. 사용자 존재 여부 확인 
	    // 리턴 타입이 int이므로 유저가 있으면 1, 없으면 0이 올 것입니다.
	    int userCount = userInfoMapper.findUserPwByUserNmAndEmailAndUserId(userInfoDTO);

	    if (userCount == 0) {
	        throw new Exception("일치하는 사용자를 찾을 수 없습니다.");
	    }

	    // 3. 새 비밀번호 암호화 (Spring Security 필수 과정)
	    // 사용자가 입력한 평문 비밀번호를 암호화하여 다시 세팅합니다.
	    String encryptedPassword = passwordEncryptor.encrypt(userInfoDTO.getNewPassword());
	    
	    // 4. 비밀번호 업데이트 (작성하신 update id="updateNewPassword" 호출)
	    
	    UserInfoDTO updatePw = new UserInfoDTO();
	    updatePw.setUserId(userInfoDTO.getUserId());
	    updatePw.setUpdId(userInfoDTO.getUserId());
	    updatePw.setNewPassword(encryptedPassword);

	    int updateResult = userInfoMapper.updateNewPassword(updatePw);

	    return updateResult > 0;
	}

	/**
	 * 
	 * 메일 보내기전 사용자 검증 체크 ( 아이디쪽 )
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userName
	 * @param email
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean checkUserExists(String userName, String email) throws Exception{
		
		UserInfoDTO dto = new UserInfoDTO();
		dto.setUserName(userName);
		dto.setEmail(email);
		
		if (!commonService.nullEmptyChkValidate(dto)) {
	        throw new Exception("입력 정보가 누락되었습니다.");
	    }
		
		boolean result = false;
		
		if (userInfoMapper.selectUserChk(dto) == 1) {
			result = true;
		}
		return result;
	}
	
	/**
	 * 
	 * 메일 보내기전 사용자 검증 체크 ( 아이디쪽 )
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userName
	 * @param email
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean checkUserBanExists(String userName, String email) throws Exception{
		
		UserInfoDTO dto = new UserInfoDTO();
		dto.setUserName(userName);
		dto.setEmail(email);
		
		if (!commonService.nullEmptyChkValidate(dto)) {
	        throw new Exception("입력 정보가 누락되었습니다.");
	    }
		
		// 1. DB에서 상태값을 먼저 가져옵니다.
	    String status = userInfoMapper.selectUserBanChk(dto);
	    
	    // 2. 일치하는 사용자가 없는 경우(null) 처리
	    if (status == null) {
	        throw new Exception("입력하신 정보와 일치하는 사용자를 찾을 수 없습니다.");
	    }
	    
	    // 3. "BANNED".equals(status) 순서로 비교하여 안전성 확보
	    // BANNED가 아니면 true를 반환합니다.
	    return !("BANNED".equalsIgnoreCase(status.trim()));
	}
	
	/**
	 * 
	 * 메일 보내기전 사용자 검증 체크 ( 비밀번호쪽 )
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userName
	 * @param email
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean checkUserPwExists(String userName, String userId, String email) throws Exception{
		
		UserInfoDTO dto = new UserInfoDTO();
		dto.setUserName(userName);
		dto.setUserId(userId);
		dto.setEmail(email);
		
		if (!commonService.nullEmptyChkValidate(dto)) {
	        throw new Exception("입력 정보가 누락되었습니다.");
	    }
		
		boolean result = false;
		
		if (userInfoMapper.selectUserChk(dto) == 1) {
			result = true;
		}
		return result;
	}
	
	/**
	 * 
	 * 메일 보내기전 사용자 벤 검증 체크 ( 비밀번호쪽 )
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userName
	 * @param email
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean checkUserBanPwExists(String userName, String userId, String email) throws Exception{
		
		UserInfoDTO dto = new UserInfoDTO();
		dto.setUserName(userName);
		dto.setUserId(userId);
		dto.setEmail(email);
		
		if (!commonService.nullEmptyChkValidate(dto)) {
	        throw new Exception("입력 정보가 누락되었습니다.");
	    }
		
		// 1. 상태값을 먼저 받습니다.
	    String status = userInfoMapper.selectUserPwBanChk(dto);
	    
	    // 2. 만약 조회가 안 되었다면(null), 정보가 틀린 것입니다.
	    if (status == null) {
	        throw new Exception("입력하신 정보와 일치하는 사용자를 찾을 수 없습니다.");
	    }
	    
	    // BANNED가 아니면 true(정상) 반환
	    return !("BANNED".equalsIgnoreCase(status.trim()));
	}

	/**
	 * 
	 * 회원가입시 중복 아이디 체크
	 * @author GD
	 * @since 2026. 2. 25.
	 * @param userId
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 25.  GD       최초 생성
	 */
	@Override
	public boolean userIdDuplicationChk(String userId) throws Exception{
		
		boolean result = false;
		
		if (userInfoMapper.selectUserIdDuplicateChk(userId) > 0) {
			throw new Exception("중복된 ID로 사용이 불가능합니다.");
		} else {
			result = true;
		}

		return result;
	}

	/**
	 * 
	 * 회원가입시 중복 이메일 체크
	 * @author GD
	 * @since 2026. 2. 26.
	 * @param userId
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 26.  GD       최초 생성
	 */
	@Override
	public boolean userEmailDuplicationChk(String email) throws Exception {
		
		boolean result = false;
		
		if (userInfoMapper.selectEmailDuplicateChk(email) > 0) {
			throw new Exception("이미 가입된 이메일로 사용이 불가능합니다.");
		} else {
			result = true;
		}

		return result;
	}
	
}
