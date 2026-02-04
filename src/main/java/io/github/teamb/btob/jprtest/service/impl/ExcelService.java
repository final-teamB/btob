package io.github.teamb.btob.jprtest.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;

public interface ExcelService {
    
	// 엑셀 양식 다운로드 ( 서버에 저장된 양식 다운로드 )
	void downloadExcelTemplate(HttpServletResponse response, String fileName) throws Exception;
	
	// 엑셀 업로드 데이터 추출
    List<Map<String, Object>> uploadExcelFile(
    		MultipartFile file,
    		Map<String, String> headerMap,
    		List<String> validKeys) throws Exception;
    
    
     // 엑셀 데이터를 특정 DTO 클래스 리스트로 반환
    <T> List<T> uploadExcelToDto(MultipartFile file, 
    								Map<String, String> headerMap, 
    								List<String> validKeys, 
    								Class<T> clazz) throws Exception;
    
    /**
     * @param response     응답 객체
     * @param fileName     다운로드될 파일명
     * @param headerMap    헤더 매핑 (Key: 데이터의 영문키, Value: 엑셀에 노출할 한글명)
     * @param dataList     출력할 데이터 리스트
     */
    // 조회한 자료 엑셀다운로드
    void downloadExcel(HttpServletResponse response, 
    				String fileName, 
                    Map<String, String> headerMap, 
                    List<?> dataList) throws Exception;

}
