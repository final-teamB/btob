package io.github.teamb.btob.dto.user;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserListDTO {
    private int userNo;             // 사원 번호
    private String userId;          // 로그인 ID
    private String userName;        // 이름
    private String phone;           // 전화번호
    private String accStatus;       // 계정 상태(ACTIVE,SLEEP, STOP)
    private LocalDateTime regDtime; // 등록 일시
} 
