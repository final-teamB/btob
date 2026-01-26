package io.github.teamb.btob.dto;

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
    private String address;
    private String isRepresentative;
    private String businessNumber;
}
