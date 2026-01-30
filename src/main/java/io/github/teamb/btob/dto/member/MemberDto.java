package io.github.teamb.btob.dto.member;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class MemberDto {
    private String userId;
    private String password;
    private String userName;
    private String position;
    private String email;
    private String phone;
    
    // 주소 필드
    private String postcode;
    private String address;
    private String detailAddress;
    
    // 권한 필드 추가 (USER, MASTER, ADMIN)
    private String userType; 
    
    private String isRepresentative;
    private String businessNumber;
}