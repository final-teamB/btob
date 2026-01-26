package io.github.teamb.btob.service.statistics;

import java.util.List;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.statistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.statistics.StatisticsDTO;
import io.github.teamb.btob.mapper.statistics.StatisticsMapper;
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
	
}	
