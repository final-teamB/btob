package io.github.teamb.btob.service.adminUser;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.mapper.adminUser.AdminUserMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminUserService {

	private final AdminUserMapper adminUserMapper;
	
	// 전체 사용자 목록 조회
	public List<Map<String, Object>> getUserList() {
		
		return adminUserMapper.selectAllUsers();
	}

	// 대표 가입 승인
	public boolean approveCompany(String userId, String updId) {
		
		return adminUserMapper.updateCompanyApproval(userId, updId) > 0;
	}
	
	// 계정 상태 변경
	public boolean modifyUserStatus(String userId, String accStatus, String updId) {
		
		return adminUserMapper.updateUserStatus(userId, accStatus, updId) > 0;
	}
	
	// 신규 관리자 등록
	public boolean registerAdminUser(UserDTO userDTO, String adminId) {
		
		userDTO.setUserType("ADMIN");
	    userDTO.setAppStatus("APPROVED"); 
	    userDTO.setAccStatus("ACTIVE");
	    userDTO.setRegId(adminId);
	    userDTO.setUpdId(adminId);
	    
		return adminUserMapper.insertAdminUser(userDTO) > 0;
	}
	
	// 아이디 중복
	public boolean isIdDuplicate(String userId) {
		
	    return adminUserMapper.countByUserId(userId) > 0;
	}
}
