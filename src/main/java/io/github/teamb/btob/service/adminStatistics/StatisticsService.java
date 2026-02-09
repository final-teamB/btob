package io.github.teamb.btob.service.adminStatistics;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.adminStatistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.adminStatistics.StatisticsDTO;

public interface StatisticsService {
	
	List<StatisticsDTO> getStatsByType(String statsType);
	List<OrderStatisticsDTO> getOrderStats();
	int refreshOrderStats(int userNo);
	
	Map<String, Object> getDeliveryKPI();
	Map<String, Object> getDeliveryStatusCounts();
	List<Map<String, Object>> getDeliveryRegionStats();
	List<Map<String, Object>> getRecentDeliveryList(String type, String value);

	Map<String, Object> getUserFullData();
	List<Map<String, Object>> getFilteredUserList(String type, String value);
	
	Map<String, Object> getProductFullData();
	List<Map<String, Object>> getFilteredProductList(String type, String value);
	
	void saveAllDailySnapshots(int userNo);
	
}
