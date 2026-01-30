package io.github.teamb.btob.controller.document;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.service.document.DocumentCompletedService;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/document")
public class DocumentCompletedController {
	private final DocumentCompletedService documentcompletedService;

	public DocumentCompletedController(DocumentCompletedService documentcompletedService) {
		this.documentcompletedService = documentcompletedService;
	}
	
	// 문서 목록
	@GetMapping("/list")
	public String DocumentList(Model model) {
		List <DocumentListDTO> documentList = documentcompletedService.getDocumentList();
		
		model.addAttribute("documentList", documentList);
		return "/document/list";
	}
	
	// 문서 미리보기(PDF)
	@GetMapping("/previewPDF")
	public String previewPDF(
			@RequestParam int docId,
	        Model model) {

	    // 단건 조회
		DocumentPreviewDTO doc = documentcompletedService.getDocumentById(docId);

	    model.addAttribute("doc", doc);
	    
	    switch(doc.getDocType()) {
	    case "QUOTE": return "/document/previewQuote"; 				// 견적서
	    case "CONTRACT": return "/document/previewContract";		// 계약서
	    case "TRANSACTION": return "/document/previewTransaction";	// 거래내역서
	    default: return "/document/previewDefault";					// 예외 처리용 기본 화면
	    }
	    	 
	}
	
}
