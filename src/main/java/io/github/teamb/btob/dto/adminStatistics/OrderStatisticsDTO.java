package io.github.teamb.btob.dto.adminStatistics;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class OrderStatisticsDTO {
	private int orderStatsId;
	private StatisticsType statsType;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime statsDate;
	
	private int totalOrderCount;
	private int pendingCount;
	private int paidCount;
	private int preparingCount;
	private int shippingCount;
	private int deliveredCount;
	private int totalSalesAmount;
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private LocalDateTime executedAt;
	private String executedBy;
	private String useYn;
	private int userNo;
}
