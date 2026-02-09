package io.github.teamb.btob.common.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import io.github.teamb.btob.mapper.user.UserMapper;

@Component
public class LoginUserProvider {
	private final UserMapper userMapper;
	
	public LoginUserProvider(UserMapper userMapper) {
		this.userMapper = userMapper;
	}

	public String getLoginUserId() {
        Authentication auth = SecurityContextHolder
                .getContext()
                .getAuthentication();

        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }

        return auth.getName(); // email
    }
	
	public Integer getLoginUserNo() {
        String userId = getLoginUserId();
        if (userId == null) return null;
        return userMapper.getUserNoById(userId); // UserMapper에 해당 쿼리 추가 필요
    }
	
	public String getUserType(String userId) {
	    return userMapper.getUserTypeById(userId); 
	}
}
