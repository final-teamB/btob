package io.github.teamb.btob.jprtest.service.impl;

import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.util.UriUtils;
import org.xhtmlrenderer.pdf.ITextRenderer;

import com.lowagie.text.pdf.BaseFont;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@Service
public class PdfServiceImpl implements PdfService {

	/**
	 * 
	 * JSP TO PDF 변환 다운로드
	 * @author GD
	 * @since 2026. 1. 26.
	 * @param request		JSP 렌더링을 위한 요청 객체
	 * @param response		응답 객체
	 * @param fileName		다운로드될 파일명
	 * @param jspPath		양식으로 사용할 JSP 경로 (예: "/WEB-INF/jsp/pdf/template.jsp")
	 * @param data			JSP에 뿌려줄 데이터 (Map)
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 26.  GD       최초 생성
	 */
    @Override
    public void downloadPdfFromJsp(HttpServletRequest request, 
    							HttpServletResponse response, 
    							String fileName, 
    							String jspPath, 
    							Map<String, Object> data) throws Exception {
        
        // 1. 데이터 세팅
        if (data != null) {
            data.forEach(request::setAttribute);
        }

        // 2. 분리한 Wrapper 사용
        HtmlResponseWrapper responseWrapper = new HtmlResponseWrapper(response);

        // 3. JSP 실행 결과 캡처
        request.getRequestDispatcher(jspPath).include(request, responseWrapper);
        String htmlContent = responseWrapper.toString();

        // 4. PDF 변환 및 스트리밍 로직 (기존과 동일)
        generatePdfFromHtml(response, fileName, htmlContent);
    }

    private void generatePdfFromHtml(HttpServletResponse response, 
            String fileName, 
            String htmlContent) throws Exception {

			String encodedNm = UriUtils.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "inline; filename=\"" + encodedNm + ".pdf\"");
			
			try (OutputStream os = response.getOutputStream()) {
			ITextRenderer renderer = new ITextRenderer();
			
			// [중요] 한글 폰트 설정 (윈도우 서버 기준 맑은 고딕 경로)
			// 리눅스 서버라면 "/usr/share/fonts/..." 경로의 .ttf 파일을 지정해야 합니다.
			renderer.getFontResolver().addFont("C:/Windows/Fonts/malgun.ttf", 
			                       BaseFont.IDENTITY_H, 
			                       BaseFont.EMBEDDED);
			
			renderer.setDocumentFromString(htmlContent);
			renderer.layout();
			renderer.createPDF(os);
			}
	}
}
