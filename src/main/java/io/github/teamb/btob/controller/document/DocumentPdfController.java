package io.github.teamb.btob.controller.document;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.service.document.DocumentPdfService;
import io.github.teamb.btob.service.document.TradeDocService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/document")
@RequiredArgsConstructor
public class DocumentPdfController {

    private final DocumentPdfService documentPdfService;
    private final TradeDocService tradeDocService;

    @GetMapping("/exportPdf")
    public void exportPdf(
    		@RequestParam int docId,
            HttpServletRequest request,
            HttpServletResponse response) {

    	// 1. 먼저 문서 정보(타입 확인용)를 가져옵니다.
        DocumentPreviewDTO doc = tradeDocService.getDocumentById(docId);
        
        Object detailData = null;

        // 2. 타입에 따라 알맞은 상세 데이터를 조회합니다.
        switch (doc.getDocType()) {
            case "ESTIMATE":
                detailData = tradeDocService.getEstimateDetail(docId);
                break;
            case "PURCHASE ORDER":
            	 detailData = tradeDocService.getOrderDetail(docId);
                 break;
            case "TRANSACTION":
                // 주문서나 거래명세서는 OrderDetailDTO를 사용한다고 가정
                detailData = tradeDocService.getOrderDetail(docId); 
                break;
            case "CONTRACT":
                // 계약서 전용 DTO가 있다면 추가
                // detailData = tradeDocService.getContractDetail(docId);
                break;
        }
    	
        documentPdfService.exportPdf(docId, detailData, request, response);
    }
}
