package io.github.teamb.btob.dto.user;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = "password") // 민감 정보 제외
public class UserDTO {

    private int userNo;               // user_no
    private String userId;            // user_id
    private String password;          // password
    private String userName;          // user_name
    private String phone;             // phone
    private String email;             // email
    private String companyCd;         // company_cd
    private String userType;          // user_type (ADMIN, MASTER, USER)
    private String appStatus;         // app_status (PENDING, APPROVED, REJECTED)
    private String accStatus;         // acc_status (ACTIVE, SLEEP, STOP)
    private LocalDateTime regDtime;   // reg_dtime
    private String regId;             // reg_id
    private LocalDateTime updDtime;   // upd_dtime
    private String updId;             // upd_id
    private String useYn;             // use_yn
    private String address;           // address
    private String position;          // position
    private String businessNumber;    // business_number
    private String isRepresentative;  // is_representative

}
