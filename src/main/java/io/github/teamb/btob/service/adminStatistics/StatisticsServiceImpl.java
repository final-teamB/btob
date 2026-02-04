package io.github.teamb.btob.service.adminStatistics;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.adminStatistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.adminStatistics.StatisticsDTO;
import io.github.teamb.btob.mapper.adminStatistics.StatisticsMapper;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {
	
	private final StatisticsMapper statisticsMapper;

	@Override
	public List<StatisticsDTO> getStatsByType(String statsType) {
		return statisticsMapper.selectStatsByType(statsType);
	}

	@Override
	public List<OrderStatisticsDTO> getOrderStats() {
		return statisticsMapper.selectOrderStats();
	}

	@Override
	public int refreshOrderStats(int userNo) {
		int row = statisticsMapper.refreshOrderStats(userNo);
		return row;
	}
	
	@Override
	public Map<String, Object> getDeliveryKPI() {
	    return statisticsMapper.getDeliveryKPI();
	}

	@Override
	public Map<String, Object> getDeliveryStatusCounts() {
	    return statisticsMapper.getDeliveryStatusCounts();
	}

	@Override
	public List<Map<String, Object>> getDeliveryRegionStats() {
	    return statisticsMapper.getDeliveryRegionStats();
	}

	@Override
	public List<Map<String, Object>> getDeliveryTrend() {
	    return statisticsMapper.getDeliveryTrend();
	}
	
	@Override
    @Transactional // 하나라도 에러나면 전체 롤백
    public void saveAllDailySnapshots(int userNo) {
        statisticsMapper.refreshOrderStats(userNo);      // 1. 주문
        statisticsMapper.insertDailyDeliveryStats();   // 2. 배송 (추가됨)
        statisticsMapper.insertDailyUserStats();       // 3. 사용자
        statisticsMapper.insertDailyOilStats();        // 4. 상품
    }

    @Override
    public Map<String, Object> getUserFullData() {
        Map<String, Object> result = new HashMap<>();
        result.put("trend", statisticsMapper.selectStatsByType("USER"));
        result.put("accStatus", statisticsMapper.getUserAccStatusStats());
        result.put("appStatus", statisticsMapper.getUserAppStatusStats());
        result.put("region", statisticsMapper.getUserRegionStats());
        return result;
    }

    @Override
    public Map<String, Object> getProductFullData() {
        Map<String, Object> result = new HashMap<>();
        result.put("trend", statisticsMapper.selectStatsByType("PRODUCT"));
        result.put("topProducts", statisticsMapper.getTopSellingProducts());
        result.put("categoryStats", statisticsMapper.getCategorySalesStats());
        result.put("kpi", statisticsMapper.getProductKPI());
        return result;
    }
}	
