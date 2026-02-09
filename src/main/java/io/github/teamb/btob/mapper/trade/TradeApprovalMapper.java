package io.github.teamb.btob.mapper.trade;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.trade.TradePendingDTO;

@Mapper
public interface TradeApprovalMapper {

	List<TradePendingDTO> getTradePendingList(TradePendingDTO dto);

}
