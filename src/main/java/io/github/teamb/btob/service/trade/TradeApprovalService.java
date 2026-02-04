package io.github.teamb.btob.service.trade;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.mapper.trade.TradeApprovalMapper;

@Service
@Transactional
public class TradeApprovalService {
	private final TradeApprovalMapper tradeApprovalmapper;

	public TradeApprovalService(TradeApprovalMapper tradeApprovalmapper) {
		this.tradeApprovalmapper = tradeApprovalmapper;
	}
	
	
}
