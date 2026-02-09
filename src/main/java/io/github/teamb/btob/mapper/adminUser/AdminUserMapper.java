package io.github.teamb.btob.mapper.adminUser;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.user.UserDTO;

@Mapper
public interface AdminUserMapper {

	// 전체 사용자 목록 조회
	List<Map<String, Object>> selectAllUsers();
	
	// 대표 가입 승인
	int updateCompanyApproval(String userId);
	
	// 계정 상태 변경
	int updateUserStatus(@Param("userId") String userId, @Param("accStatus") String accStatus);
	
	// 신규 관리자 등록
	int insertAdminUser(UserDTO userDTO);
	
	// 아이디 중복
	int countByUserId(String userId);
}
