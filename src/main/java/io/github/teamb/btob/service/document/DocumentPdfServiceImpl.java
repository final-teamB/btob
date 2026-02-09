package io.github.teamb.btob.service.document;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

@Service
public class DocumentPdfServiceImpl implements DocumentPdfService{
	private final TradeDocService tradeDocService;	
	
	
	public DocumentPdfServiceImpl(TradeDocService tradeDocService) {
		super();
		this.tradeDocService = tradeDocService;
	}


	@Override
	public void exportPdf(int docId, HttpServletRequest request, HttpServletResponse response) {
		try {
            // 1. 문서 조회
            DocumentPreviewDTO doc =
            		tradeDocService.getDocumentById(docId);

            // 2. JSP 경로 결정
            String jspPath = resolveJspPath(doc.getDocType());

            // 3. JSP → HTML
            String html = renderJspToHtml(
                    request, response, jspPath, doc);

            // 4. HTML → PDF
            generatePdf(html, request, response, doc);

        } catch (Exception e) {
            throw new RuntimeException("PDF 변환 실패", e);
        }
		
	}

		
	private String resolveJspPath(String docType) {
	    switch (docType) {
	        case "ESTIMATE":
	            return "/WEB-INF/views/document/previewEst.jsp";
	        case "CONTRACT":
	            return "/WEB-INF/views/document/previewContract.jsp";
	        case "TRANSACTION":
	            return "/WEB-INF/views/document/previewTransaction.jsp";
	        default:
	            return "/WEB-INF/views/document/previewDefault.jsp";
	    }
	}
	
	private String renderJspToHtml(
	        HttpServletRequest request,
	        HttpServletResponse response,
	        String jspPath,
	        DocumentPreviewDTO doc) throws Exception {

		request.setAttribute("doc", doc);

	    // 응답 인코딩 설정
	    response.setCharacterEncoding("UTF-8");
	    
	    StringWriter sw = new StringWriter();
	    HttpServletResponseWrapper wrapper = new HttpServletResponseWrapper(response) {
	        @Override
	        public PrintWriter getWriter() {
	            // 인코딩이 보장된 PrintWriter 반환
	            return new PrintWriter(sw);
	        }
	    };

	    RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
	    dispatcher.include(request, wrapper);

	    String result = sw.toString();
	    if (result == null || result.trim().isEmpty()) {
	        throw new RuntimeException("JSP 렌더링 결과가 비어있습니다. 경로를 확인하세요: " + jspPath);
	    }
	    return result;
	}
	
	private void generatePdf(
	        String html,
	        HttpServletRequest request,
	        HttpServletResponse response, 
	        DocumentPreviewDTO doc) throws Exception {

		String fileName = String.format(
		        "%s_%s.pdf",
		        doc.getDocType(),
		        doc.getDocNo()
		    );

		    response.setContentType("application/pdf");
		    response.setHeader(
		        "Content-Disposition",
		        "attachment; filename=\"" + fileName + "\""
		    );

	    PdfRendererBuilder builder = new PdfRendererBuilder();
	    builder.withHtmlContent(html, request.getRequestURL().toString());

	    builder.useDefaultPageSize(
	    	    210, 297,
	    	    PdfRendererBuilder.PageSizeUnits.MM
	    	);
	    
	    // 한글 폰트
	    ClassPathResource font = new ClassPathResource("fonts/NanumGothic.ttf");
	    builder.useFont(
	        () -> {
				try {
					return font.getInputStream();
				} catch (IOException e) {
					 throw new RuntimeException("NanumGothic 폰트 로드 실패", e);
				}
			},
	        "NanumGothic"
	    );

	    try (OutputStream os = response.getOutputStream()) {
	        builder.toStream(os);
	        builder.run();
	    }
	}
	
}
