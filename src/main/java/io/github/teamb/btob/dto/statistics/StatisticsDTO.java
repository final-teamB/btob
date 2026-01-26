package io.github.teamb.btob.dto.statistics;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class StatisticsDTO {
	private int statsId;
	private LocalDateTime statsDate;
	private StatisticsType statsType;
	private String statsName;
	private int statsValue;
	
	private LocalDateTime regDtime;
	private String regId;
	private LocalDateTime updDtime;
	private String updId;
	private String useYn;
	private int userNo;
	
	// 유형 이름 반환 메서드
	public String getTypeName() {
		return (this.statsType != null) ? this.statsType.getDescription() : "";
	}
}
