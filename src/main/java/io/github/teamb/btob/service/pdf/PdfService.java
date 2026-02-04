package io.github.teamb.btob.service.pdf;

import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface PdfService {
	
		// PDF 다운로드 ( 단일 )
	    void downloadPdfFromJsp(HttpServletRequest request, 
	    						HttpServletResponse response, 
	                            String fileName, 
	                            String jspPath, 
	                            Map<String, Object> data) throws Exception;
}

