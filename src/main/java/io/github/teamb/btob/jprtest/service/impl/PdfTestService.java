package io.github.teamb.btob.jprtest.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import io.github.teamb.btob.jprtest.dto.AtchFileDto;
import io.github.teamb.btob.jprtest.mapper.AtchFileMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PdfTestService {

    private final AtchFileMapper atchFileMapper; // 이전에 만든 엑셀용 매퍼 재사용
    private final PdfService pdfService;         // 공통 PDF 모듈

    /**
     * 
     * PDF 생성
     * @author GD
     * @since 2026. 1. 27.
     * @param request
     * @param response
     * @param param			자료 조건값 파라미터 MAP
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 27.  GD       최초 생성
     */
    public void downloadPdf(HttpServletRequest request, 
    						HttpServletResponse response, 
    						Map<String, Object> param) throws Exception {
        
        // 1. DB에서 데이터 조회 (이전에 만든 selectFileListByRef 활용)
    	List<AtchFileDto> dataList = atchFileMapper.selectFileListByRef(param);

        // 2. JSP 양식에 뿌려줄 데이터 정리 (Map)
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("dataList", dataList);
        dataMap.put("printDate", new Date());
        dataMap.put("reportTitle", "2026년도 PDF 테스트");

        // 3. 파일명 설정
        String fileName = "PDF_Report_" + System.currentTimeMillis();

        // 4. 공통 PDF 서비스 호출 (JSP 경로 전달)
        // 이 메서드 안에서 HtmlResponseWrapper를 이용해 JSP를 HTML로 변환합니다.
        pdfService.downloadPdfFromJsp(
            request, 
            response, 
            fileName, 
            "/WEB-INF/jsp/jjjtest/pdfTemp.jsp", 
            dataMap
        );
    }
}
