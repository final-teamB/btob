package io.github.teamb.btob.dto.adminStatistics;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class OrderStatisticsDTO {
	private int orderStatsId;
	private StatisticsType statsType;
	private LocalDateTime statsDate;
	
	private int totalOrderCount;
	private int pendingCount;
	private int paidCount;
	private int preparingCount;
	private int shippingCount;
	private int deliveredCount;
	private int totalSalesAmount;
	
	private LocalDateTime executedAt;
	private String executedBy;
	private String useYn;
	private int userNo;
}
