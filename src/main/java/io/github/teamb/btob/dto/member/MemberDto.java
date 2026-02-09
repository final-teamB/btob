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
    
    // [공통 주소 필드] MASTER는 회사주소, USER는 거주지주소로 저장됨 [cite: 15]
    private String postcode;
    private String address;
    private String detailAddress;
    
    // 권한 및 상태 정보 [cite: 15]
    private String userType;           // ADMIN, MASTER, USER
    private String isRepresentative;   // Y/N
    private String businessNumber;     // 사업자번호
    private String companyName;        // 대표가 직접 입력한 회사명
    private String companyCd;          // 일반회원이 선택한 회사 코드
}