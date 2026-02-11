package io.github.teamb.btob.controller.document;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.document.DocumentListDTO;
import io.github.teamb.btob.dto.document.DocumentMemoActionDTO;
import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import io.github.teamb.btob.dto.trade.TradePendingDTO;
import io.github.teamb.btob.service.document.TradeDocService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/document")
@RequiredArgsConstructor
public class TradeDocController {
	private final TradeDocService tradeDocService;
	private final LoginUserProvider loginUserProvider;
	
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
	public String previewEst(@RequestParam(value="orderId", required=false) Integer orderId, Model model) {
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
		// 1. 주문 기본 정보 및 품목 리스트 조회 (DB 재조회)
	    // 보통 orderId 하나로 여러 품목이 나올 수 있도록 itemList로 가져옵니다.
	    List<TradePendingDTO> itemList = tradeDocService.getOrderDetailList(orderId);
	    
	    if (itemList != null && !itemList.isEmpty()) {
	        // 2. 상단 업체/요청자 정보 (리스트의 첫 번째 항목 기준)
	        model.addAttribute("info", itemList.get(0));
	        
	        // 3. 테이블에 뿌릴 품목 전체 리스트
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("userType", userType);
	        
	        // 4. cartIds 추출 (발주 승인 시 필요)
	        // 리스트 내의 모든 cartId를 콤마로 연결한 문자열 생성
	        String cartIds = itemList.stream()
	                                 .map(item -> String.valueOf(item.getCartId()))
	                                 .collect(Collectors.joining(","));
	        model.addAttribute("cartIds", cartIds);
	    }
	    
	    return "document/previewEst";
	}

	@GetMapping("/previewOrder")
	public String previewOrder(@RequestParam(value="orderId", required=false) Integer orderId, Model model) {
		String userType = loginUserProvider.getUserType(loginUserProvider.getLoginUserId());
		// 1. 주문 기본 정보 및 품목 리스트 조회 (DB 재조회)
	    // 보통 orderId 하나로 여러 품목이 나올 수 있도록 itemList로 가져옵니다.
	    List<TradePendingDTO> itemList = tradeDocService.getOrderDetailList(orderId);
	    
	    if (itemList != null && !itemList.isEmpty()) {
	        // 2. 상단 업체/요청자 정보 (리스트의 첫 번째 항목 기준)
	        model.addAttribute("info", itemList.get(0));
	        
	        // 3. 테이블에 뿌릴 품목 전체 리스트
	        model.addAttribute("itemList", itemList);
	        model.addAttribute("userType", userType);
	        
	        // 4. cartIds 추출 (발주 승인 시 필요)
	        // 리스트 내의 모든 cartId를 콤마로 연결한 문자열 생성
	        String cartIds = itemList.stream()
	                                 .map(item -> String.valueOf(item.getCartId()))
	                                 .collect(Collectors.joining(","));
	        model.addAttribute("cartIds", cartIds);
	    }

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
