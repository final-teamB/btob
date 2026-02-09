package io.github.teamb.btob.service.adminStatistics;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.adminDelivery.DeliveryStatus;
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

    @Override
    public List<Map<String, Object>> getRecentDeliveryList(String type, String value) {
        Map<String, Object> params = new HashMap<>();
        params.put("type", type);
        params.put("value", value);
        
        List<Map<String, Object>> list = statisticsMapper.getRecentDeliveryList(params); 
        
        if (list != null) {
            for (Map<String, Object> item : list) {
                Object statusObj = item.get("statusName");
                if (statusObj == null) statusObj = item.get("delivery_status");

                if (statusObj != null) {
                    String statusStr = statusObj.toString().trim();
                    try {
                        // Enum 변환 (READY -> 상품준비중 등)
                        DeliveryStatus status = DeliveryStatus.valueOf(statusStr);
                        item.put("statusName", status.getDescription());
                    } catch (Exception e) {
                        // Enum에 없는 값이면 그냥 원문 그대로 노출해서 에러 방지
                        item.put("statusName", statusStr);
                    }
                } else {
                    item.put("statusName", "-"); // 데이터가 아예 없을 때
                }
            }
        }
        return list;
    }
    
    @Override
    public List<Map<String, Object>> getFilteredUserList(String type, String value) {
        Map<String, Object> params = new HashMap<>();
        params.put("type", type);
        params.put("value", value);
        
        List<Map<String, Object>> list = statisticsMapper.getFilteredUserList(params);
        
        return list;
    }
    
    @Override
    public List<Map<String, Object>> getFilteredProductList(String type, String value) {
        Map<String, Object> params = new HashMap<>();
        params.put("type", type);
        params.put("value", value);
        
        // Mapper에서 가져온 데이터 리스트 반환
        List<Map<String, Object>> list = statisticsMapper.getFilteredProductList(params);
        
        // 필요 시 여기서 가공 로직 추가 (단가 포맷팅 등) 가능
        return list;
    }
}	
