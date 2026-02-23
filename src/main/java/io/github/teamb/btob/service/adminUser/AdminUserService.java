package io.github.teamb.btob.service.adminUser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.mapper.adminUser.AdminUserMapper;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminUserService {

    private final NotificationService notificationService;
	private final AdminUserMapper adminUserMapper;
	
	// 전체 사용자 목록 조회
	public List<Map<String, Object>> getUserList() {
		
		return adminUserMapper.selectAllUsers();
	}

	// 대표 가입 승인, 이력 등록
    public boolean approveCompany(String userId, String adminId) {
        String prevStatus = adminUserMapper.selectUserCurrStatus(userId);
        
        int update = adminUserMapper.updateCompanyApproval(userId, adminId);
        if (update > 0) {
            saveHistory(userId, prevStatus, "APPROVED", "가입 승인", "관리자 승인 처리", adminId);
            
            notificationService.send(userId, "SYSTEM", 0, "회원가입 신청이 승인되었습니다. 다시 로그인해주세요.", adminId);
            return true;
        }
        return false;
    }

    // 대표 가입 반려, 이력 등록
    public boolean rejectCompany(String userId, String rejectReason, String adminId) {
        String prevStatus = adminUserMapper.selectUserCurrStatus(userId);
        
        int update = adminUserMapper.updateCompanyReject(userId, rejectReason, adminId);
        if (update > 0) {
            saveHistory(userId, prevStatus, "REJECTED", "가입 반려", rejectReason, adminId);
            
            try {
                String title = "[가입 반려] 회원가입 신청이 반려되었습니다.";
                String message = "사유: " + rejectReason;
                
                notificationService.send(userId, "APPROVAL", 0, title + " " + message, adminId);
            } catch (Exception e) {
                System.err.println("알림 발송 실패: " + e.getMessage());
            }
            return true;
        }
        return false;
    }
    
    // 이력 조회 API용
    public List<Map<String, Object>> getUserHistory(String userId) {
        
    	return adminUserMapper.selectUserHistory(userId);
    }

    // [내부 공통 메서드] 이력 저장 로직 분리
    private void saveHistory(String userId, String prev, String curr, String nm, String reason, String adminId) {
       
    	Map<String, Object> hist = new HashMap<>();
        hist.put("userId", userId);
        hist.put("prevStatusCd", prev);
        hist.put("currStatusCd", curr);
        hist.put("statusNm", nm);
        hist.put("reason", reason);
        hist.put("regId", adminId);
        adminUserMapper.insertUserHistory(hist);
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
