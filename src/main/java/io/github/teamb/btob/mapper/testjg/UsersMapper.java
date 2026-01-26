package io.github.teamb.btob.mapper.testjg;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.testjg.Users;


@Mapper
public interface UsersMapper {
	int insertUsers(Users users);
	
	 // 중복 체크
    int checkUserId(String userId);

    int checkCompanyCd(String companyCd);
}
