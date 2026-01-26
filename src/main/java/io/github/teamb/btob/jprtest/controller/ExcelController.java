package io.github.teamb.btob.jprtest.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.jprtest.dto.AtchFileDto;
import io.github.teamb.btob.jprtest.service.impl.ExcelTestService;
import io.github.teamb.btob.jprtest.service.impl.FileService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/jjjtest")
public class ExcelController {
	
	private final ExcelTestService excelTestService;
	private final FileService fileService;
	
	/**
     * 1. 엑셀 테스트 페이지 이동
     * 접속 주소: http://localhost/excel/test
     */
    @GetMapping("/excel")
    public String excelTestPage() {
        return "jjjtest/excelTest"; // src/main/webapp/WEB-INF/views/excel/excelTest.jsp
    }

    /**
     * 2. 엑셀 양식 다운로드
     */
    @GetMapping("/download/template")
    public void downloadTemplate(HttpServletResponse response) {
        try {
            excelTestService.processTempDownload(response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 3. 엑셀 업로드 처리 (API)
     */
    @PostMapping("/upload")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadExcel(@RequestParam("excelFile") MultipartFile file) {
        
    	Map<String, Object> result = new HashMap<String, Object>();
        
        try {
            // 1. 비즈니스 서비스(UserTestService) 호출
            // 서비스 내부에서 excelService(공통모듈)를 호출하여 파싱하고 DB에 저장까지 완료함
        	excelTestService.processUpload(file);
            
            result.put("status", "success");
            result.put("message", "성공적으로 업로드되었습니다.");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            e.printStackTrace(); // 서버 로그 확인용
            
            result.put("status", "error");
            result.put("message", "업로드 중 오류 발생: " + e.getMessage());
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }
    
    /**
     * 조회 데이터 다운로드
     */
    @GetMapping("/download/excellist")
    public void downloadUserList(HttpServletResponse response, 
                                 @RequestParam("refTypeCd") String refTypeCd, 
                                 @RequestParam("refId") int refId) { // 명시적으로 받기
        try {
            // 1. 서비스에 넘길 파라미터 맵 생성
            Map<String, Object> param = new HashMap<>();
            param.put("refTypeCd", refTypeCd);
            param.put("refId", refId);

            // 2. 서비스 호출
            excelTestService.downloadUserExcel(response, param);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    ///////////////////////////////////////////////////////
    /**
     * 테이블 조회를 위한 데이터 리스트 반환 (AJAX용)
     */
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getFileList(
            @RequestParam("refTypeCd") String refTypeCd, 
            @RequestParam("refId") int refId) {
        
        try {
            // 정상 조회
            List<AtchFileDto> list = fileService.getFilesByRef(refTypeCd, refId);
            return ResponseEntity.ok(list);
            
        } catch (Exception e) {
            // 에러 발생 시 로그를 찍고 500 에러와 메시지 반환
            e.printStackTrace(); 
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("데이터 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

}
