package io.github.teamb.btob.service.statistics;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.statistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.statistics.StatisticsDTO;

public interface StatisticsService {
	
	List<StatisticsDTO> getStatsByType(String statsType);
	
	List<OrderStatisticsDTO> getOrderStats();
	
	int refreshOrderStats(int userNo);
}
