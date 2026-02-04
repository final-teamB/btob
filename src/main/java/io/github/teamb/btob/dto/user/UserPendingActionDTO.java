package io.github.teamb.btob.dto.user;

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
public class UserPendingActionDTO {
    private int userNo;       // 사원 번호
    private String appStatus;  // APPROVED / REJECTED
}