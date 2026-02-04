package io.github.teamb.btob.service.excel;

import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.excel.ExcelUploadResult;
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
    								List<String> requiredKeys,
    								Class<T> clazz) throws Exception;
    
    // 엑셀 데이터를 DB에 저장하고 성공/실패 결과를 반환
    <T> ExcelUploadResult<T> uploadAndSave (
            MultipartFile file, 
            Map<String, String> headerMap, 
            List<String> validKeys, 
            List<String> requiredKeys, 
            Class<T> clazz,
            Consumer<T> saver);
    
    // 실패 내역 전용 엑셀 다운로드
    void downloadFailReport(HttpServletResponse response, 
    						List<ExcelUploadResult.ExcelFailDetail> failList) throws Exception;
    
    // 조회한 자료 엑셀다운로드
    void downloadExcel(HttpServletResponse response, 
    				String fileName, 
                    Map<String, String> headerMap, 
                    List<?> dataList) throws Exception;

}
