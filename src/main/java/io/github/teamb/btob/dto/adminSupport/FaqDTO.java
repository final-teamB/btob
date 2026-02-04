package io.github.teamb.btob.dto.adminSupport;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class FaqDTO {

	private int faqId;
	private String category;
	private String question;
	private String answer;
	
	private LocalDateTime regDtime;
	private String regId;
	private LocalDateTime updDtime;
	private String updId;
	private String useYn;
	private int userNo;
	
	private String searchKeyword;
}
