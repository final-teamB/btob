package io.github.teamb.btob.service.document;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.springframework.stereotype.Service;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.options.LoadState;

import io.github.teamb.btob.dto.document.DocumentPreviewDTO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;

@Service
public class DocumentPdfServiceImpl implements DocumentPdfService {

    private final TradeDocService tradeDocService;

    public DocumentPdfServiceImpl(TradeDocService tradeDocService) {
        this.tradeDocService = tradeDocService;
    }

    @Override
    public void exportPdf(int docId, Object detailData, HttpServletRequest request, HttpServletResponse response) {
        try {
            // 1. 문서 데이터 조회
            DocumentPreviewDTO doc = tradeDocService.getDocumentById(docId);
            
            // 2. 문서 타입에 따른 JSP 경로 결정
            String jspPath = resolveJspPath(doc.getDocType());

            // 3. JSP를 HTML 문자열로 렌더링
            String html = renderJspToHtml(request, response, jspPath, detailData, doc);

            // 4. Playwright를 사용하여 HTML을 PDF로 변환 및 응답 전송
            generatePdfWithPlaywright(html, response, doc);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("PDF 변환 및 다운로드 실패", e);
        }
    }

    private String resolveJspPath(String docType) {
        switch (docType) {
            case "ESTIMATE":       return "/WEB-INF/views/document/previewEst.jsp";
            case "PURCHASE_ORDER": return "/WEB-INF/views/document/previewOrder.jsp";
            case "CONTRACT":       return "/WEB-INF/views/document/previewContract.jsp";
            case "TRANSACTION":    return "/WEB-INF/views/document/previewTransaction.jsp";
            default:               return "/WEB-INF/views/document/previewDefault.jsp";
        }
    }

    private String renderJspToHtml(HttpServletRequest request, HttpServletResponse response, 
                                   String jspPath, Object detailData, DocumentPreviewDTO doc) throws Exception {
    	//request.setAttribute("info", detailData);
        request.setAttribute("doc", doc); // 문서 번호 등을 위해 유지
        request.setAttribute("mode", "preview");

        if (detailData == null) {
            // null일 경우 에러를 던지거나 빈 객체를 넣어 렌더링 에러 방지
            throw new RuntimeException("상세 데이터를 찾을 수 없습니다. (docId: " + doc.getDocId() + ")");
        }
        
        // 이제 안전하게 getClass() 사용 가능
        request.setAttribute("info", detailData);
        
        // Reflection을 이용해 itemList 추출 (가장 편한 방법)
        try {
            java.lang.reflect.Method getItems = detailData.getClass().getMethod("getItemList");
            request.setAttribute("itemList", getItems.invoke(detailData));
        } catch (NoSuchMethodException e) {
            // 1. 현재 문서가 TRANSACTION인지 확인
            boolean isTransaction = "TRANSACTION".equals(doc.getDocType()); 

            if (isTransaction) {
            } else {
                // 그 외(견적서, 주문서 등) 문서에서 리스트가 없다면 데이터 오류로 판단하여 에러 발생
                throw new RuntimeException("해당 문서 타입은 품목 리스트(itemList)가 필수입니다.", e);
            }
        } catch (Exception e) {
            // 그 외 리플렉션 실행 중 발생하는 보안/접근 에러 처리
            throw new RuntimeException("데이터 추출 중 오류가 발생했습니다.", e);
        }

        response.setCharacterEncoding("UTF-8");
        StringWriter sw = new StringWriter();
        
        HttpServletResponseWrapper wrapper = new HttpServletResponseWrapper(response) {
            @Override
            public PrintWriter getWriter() {
                return new PrintWriter(sw);
            }
        };

        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.include(request, wrapper);

        return sw.toString();
    }

    private void generatePdfWithPlaywright(String html, HttpServletResponse response, DocumentPreviewDTO doc) throws Exception {
        String fileName = String.format("%s_%s.pdf", doc.getDocType(), doc.getDocNo());

        // HTTP 헤더 설정
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Playwright 엔진 구동
        try (Playwright playwright = Playwright.create()) {
            // 브라우저 실행 (Headless 모드)
        	Browser browser = playwright.chromium().launch(new BrowserType.LaunchOptions()
        		    .setHeadless(true)
        		    .setArgs(java.util.Arrays.asList(
        		        "--no-sandbox", 
        		        "--disable-setuid-sandbox",
        		        "--disable-dev-shm-usage" // 메모리 부족 방지 (리눅스 필수)
        		    )));
            BrowserContext context = browser.newContext();
            Page page = context.newPage();
            
            page.emulateMedia(new Page.EmulateMediaOptions().setMedia(com.microsoft.playwright.options.Media.PRINT));
            
            // 1. HTML 주입
            page.setContent(html);

            // 2. Tailwind CSS 및 리소스 로딩 대기 (네트워크 활동이 없을 때까지)
            page.waitForLoadState(LoadState.NETWORKIDLE);
            
                     
            Page.PdfOptions pdfOptions = new Page.PdfOptions()
                    .setFormat("A4")
                    .setPrintBackground(true) // 배경색/테두리 포함
                    .setScale(0.85)          // 배율 적용
                    .setMargin(new com.microsoft.playwright.options.Margin()
                        .setTop("15mm")       // 상단 여백을 조금 더 주어 안정감 확보
                        .setBottom("15mm")
                        .setLeft("10mm")
                        .setRight("10mm"));

            byte[] pdfBytes = page.pdf(pdfOptions);

            // 4. 결과 출력
            try (OutputStream os = response.getOutputStream()) {
                os.write(pdfBytes);
                os.flush();
            }

            browser.close();
        }
    }
}