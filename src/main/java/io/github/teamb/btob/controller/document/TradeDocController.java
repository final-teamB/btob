package io.github.teamb.btob.controller.document;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentMemoActionDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.service.document.TradeDocService;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/document")
public class TradeDocController {
	private final TradeDocService tradeDocService;

	public TradeDocController(TradeDocService tradeDocService) {
		this.tradeDocService = tradeDocService;
	}
	
	// 메모 수정
	@PostMapping("/modifyMemo")
	public String modifyMemo(DocumentMemoActionDTO dma) {
		tradeDocService.modifyMemo(dma);
		return "redirect:/document/list";
	}
	
	// 문서 목록
	@GetMapping("/list")
	public String DocumentList(
			@RequestParam(required = false) String docType,
    		@RequestParam(required = false) String keyword,
			Model model) {
		List <DocumentListDTO> documentList = tradeDocService.getDocumentList(docType, keyword);
		
		model.addAttribute("documentList", documentList);
		model.addAttribute("pageTitle", "문서리스트");
		model.addAttribute("content", "/document/list.jsp");
		return "layout/layout";
	}
	
	// 문서 미리보기(PDF)
	@GetMapping("/previewPDF")
	public String previewPDF(
			@RequestParam int docId,
	        Model model) {

	    // 단건 조회
		DocumentPreviewDTO doc = tradeDocService.getDocumentById(docId);
		System.out.println("========== 요청받은 문서 ID: " + docId);
	    model.addAttribute("doc", doc);
	    
	    switch(doc.getDocType()) {
	    case "ESTIMATE": return "/document/previewEst"; 				// 견적서
	    case "CONTRACT": return "document/previewContract";		// 계약서
	    case "TRANSACTION": return "document/previewTransaction";	// 거래내역서
	    default: return "document/previewDefault";					// 예외 처리용 기본 화면
	    }
	    	 
	}
	
	@GetMapping("/previewEst")
	public String previewEst() {
		return "document/previewEst";
	}
	
	@GetMapping("/previewOrder")
	public String previewOrder() {
		return "document/previewOrder";
	}
	
	@GetMapping("/previewContract")
	public String previewContract() {
		return "document/previewContract";
	}
	
	@GetMapping("/previewTransaction")
	public String previewTransaction() {
		return "document/previewTransaction";
	}
	
	
}
