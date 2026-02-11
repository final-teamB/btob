package io.github.teamb.btob.service.document;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentMemoActionDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.mapper.document.TradeDocMapper;
import jakarta.servlet.http.HttpServletResponse;

@Service
@Transactional
public class TradeDocService {
	private final TradeDocMapper tradeDocMapper;

	public TradeDocService(TradeDocMapper tradeDocMapper) {
		this.tradeDocMapper = tradeDocMapper;
	}
	
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

	public List<TradePendingDTO> getOrderDetailList(int orderId) {
		return tradeDocMapper.getOrderDetailList(orderId);
	}
}
