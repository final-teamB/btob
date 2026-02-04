package io.github.teamb.btob.dto.user;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserStatusDTO {
	  private int userNo;
	  private String accStatus; // ACTIVE, SLEEP, STOP
	  private String updId;
	  private String useYn;
}
