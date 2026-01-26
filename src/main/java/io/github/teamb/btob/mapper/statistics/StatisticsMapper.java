  package io.github.teamb.btob.mapper.statistics;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.statistics.OrderStatisticsDTO;
import io.github.teamb.btob.dto.statistics.StatisticsDTO;

@Mapper
public interface StatisticsMapper {

	List<StatisticsDTO> selectStatsByType(@Param("statsType") String statsType);
	
	// 주문 전용
	List<OrderStatisticsDTO> selectOrderStats();
	
	// 주문 데이터 저장
	int refreshOrderStats(@Param("userNo") int userNo);
}
