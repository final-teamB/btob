package io.github.teamb.btob.service.document;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentMemoActionDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.dto.trade.EstimateDetailDTO;
import io.github.teamb.btob.dto.trade.OrderDetailDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.mapper.document.TradeDocMapper;
import io.github.teamb.btob.mapper.trade.TradeApprovalMapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class TradeDocService {
	private final TradeDocMapper tradeDocMapper;
	private final TradeApprovalMapper tradeApprovalMapper;
	
	// 메모수정
	public void modifyMemo(DocumentMemoActionDTO dma) {
		tradeDocMapper.modifyMemo(dma);
	}
	
	// pdf미리보기
	public DocumentPreviewDTO getDocumentById(int docId) {
		return tradeDocMapper.getDocumentById(docId);
	}

	// 문서리스트
	public List<DocumentListDTO> getDocumentList(String docType, String keyword) {
		return tradeDocMapper.getDocumentList(docType, keyword);
	}


	public EstimateDetailDTO getEstimateDetail(Integer orderId) {
		return tradeApprovalMapper.getEstimateDetail(orderId);
	}

	public OrderDetailDTO getOrderDetail(Integer orderId) {
		return tradeApprovalMapper.getOrderDetail(orderId);
	}

}
