package io.github.teamb.btob.dto.adminUser;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class UserHistoryDTO {
	private int histNo;
	private String userId;
	private String prevStatusCd;
	private String currStatusCd;
	private String statusNm;
	private String adminId;
	private String reason;
	private LocalDateTime regDtime;
}
