  package io.github.teamb.btob.mapper.adminStatistics;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.adminStatistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.adminStatistics.StatisticsDTO;

@Mapper
public interface StatisticsMapper {

	List<StatisticsDTO> selectStatsByType(@Param("statsType") String statsType);
	List<OrderStatisticsDTO> selectOrderStats();
	
	int refreshOrderStats(@Param("executedBy") String userId);
	
    Map<String, Object> getDeliveryKPI();
    Map<String, Object> getDeliveryStatusCounts();
    List<Map<String, Object>> getDeliveryRegionStats();
    List<Map<String, Object>> getRecentDeliveryList(Map<String, Object> params);
    
    void insertDailyDeliveryStats();
    
    List<Map<String, Object>> getUserAccStatusStats();
    List<Map<String, Object>> getUserAppStatusStats();
    List<Map<String, Object>> getUserRegionStats();
    List<Map<String, Object>> getFilteredUserList(Map<String, Object> params);
    
    void insertDailyUserStats();
    
    Map<String, Object> getProductKPI();
    List<Map<String, Object>> getTopSellingProducts();
    List<Map<String, Object>> getCategorySalesStats();
    List<Map<String, Object>> getFilteredProductList(Map<String, Object> params);
    
    void insertDailyOilStats();
}
