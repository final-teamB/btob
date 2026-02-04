package io.github.teamb.btob.jprtest.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.github.teamb.btob.jprtest.service.impl.PdfTestService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/jjjtest")
@RequiredArgsConstructor
public class PdfController {

    private final PdfTestService pdfTestService;
    
    
    /**
     * PDF 테스트 페이지로 이동 (pdfTest.jsp)
     */
    @GetMapping("/pdftest")
    public String goPdfTestPage() {
        // prefix: /WEB-INF/jsp/, suffix: .jsp 설정 기준
        return "jjjtest/pdfTest"; 
    }

    /**
     * PDF 다운로드 요청 처리
     */
    @GetMapping("/download/pdflist")
    public void downloadUserPdf(HttpServletRequest request, 
    						HttpServletResponse response,
    						@RequestParam("refTypeCd") String refTypeCd, 
                            @RequestParam("refId") int refId) {
        try {

        	Map<String, Object> param = new HashMap<>();
            param.put("refTypeCd", refTypeCd);
            param.put("refId", refId);
            
            // 비즈니스 서비스 호출
        	pdfTestService.downloadPdf(request, response, param);
        } catch (Exception e) {
        	
            e.printStackTrace();
            // 에러 발생 시 사용자에게 알림을 주거나 로그를 남깁니다.
        }
    }
}
