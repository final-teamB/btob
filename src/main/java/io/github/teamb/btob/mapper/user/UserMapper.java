package io.github.teamb.btob.mapper.user;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.dto.user.UserListDTO;
import io.github.teamb.btob.dto.user.UserPendingActionDTO;
import io.github.teamb.btob.dto.user.UserPendingDTO;
import io.github.teamb.btob.dto.user.UserStatusDTO;

@Mapper
public interface UserMapper {
	
	// 사원 회원가입 인증
	void processPendingUser(UserPendingActionDTO upa);
	
	// 사원 회원가입 인증 대기 목록
	List<UserPendingDTO> getPendingUsers();
	
	// 사원 상태 수정
	void modifyUserStatus(UserStatusDTO userStatus);
	
	// 사원리스트
	List<UserListDTO> getUserList(
	        @Param("accStatus") String accStatus, 
	        @Param("keyword") String keyword
	    );
	
	// 사원 엑셀 등록
	int insertUsers(List<UserDTO> userList);
	
	// 중복 체크
	int checkUserId(String userId);
	
	int checkCompanyCd(String companyCd);




}
