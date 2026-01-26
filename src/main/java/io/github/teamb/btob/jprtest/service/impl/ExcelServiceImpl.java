package io.github.teamb.btob.jprtest.service.impl;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletResponse;

@Service
public class ExcelServiceImpl implements ExcelService {

	/**
	 * 
	 * 엑셀 양식 다운로드 ( 서버에 저장된 양식 다운로드 )
	 * @author GD
	 * @since 2026. 1. 26.
	 * @param response 응답 객체
	 * @param fileName 양식 파일 이름
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 1. 26.  GD       최초 생성
	 */
    @Override
    public void downloadExcelTemplate(HttpServletResponse response, String fileName) throws Exception {
    	
        // 1. 리소스 경로에서 파일 읽기 (src/main/resources/excel/sample.xlsx)
    	// 사용자에게 건내줄 파일 양식
        ClassPathResource resource = new ClassPathResource("excel/" + fileName);

        if (!resource.exists()) {
        	
            throw new Exception("양식 파일을 찾을 수 없습니다.");
        }

        // 2. 파일명 인코딩 (한글 깨짐 방지)
        // 사용자가 받게 될 파일명
        String downloadName = "데이터_업로드_양식.xlsx";
        String encodedNm = UriUtils.encode(downloadName, StandardCharsets.UTF_8).replace("+", "%20");

        // 3. 응답 헤더 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedNm + "\"");
        
        // 4. 스트림 복사
        try (InputStream is = resource.getInputStream()) {
        	
            FileCopyUtils.copy(is, response.getOutputStream());
            response.getOutputStream().flush();
        }
    }
    
    /**
     * 
     * 엑셀 업로드 데이터 추출
     * @author GD
     * @since 2026. 1. 26.
     * @param file 엑셀 파일
     * @param headerMap 매핑 정보 ( Key: 엑셀 한글 헤더명, Value: DTO/SQL에서 쓸 영문 키명 )
     * @param validKeys ( 영문 키명 리스트 ) 
     * ex) headerMap은 ( 사용자ID, userId ) , validKeys( userId )
     * 더블체크 때문에 validKeys 넣었음 
     * @return 업로드 할 엑셀 안의 데이터 ( 키, 값 ) 형태 리스트(map)
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public List<Map<String, Object>> uploadExcelFile(
    		MultipartFile file, 
    		Map<String, String> headerMap,
    		List<String> validKeys) throws Exception {
    	
    	// 개발자가 설정한 영문 Key(Value)들이 유효한지 체크 ( userId, userNm 등등 )
        for (String mappedKey : headerMap.values()) {
            if (!validKeys.contains(mappedKey)) {
            
            	// "user Id" 처럼 오타가 나면 여기서 바로 예외 발생
                throw new Exception("잘못된 시스템 매핑 키가 감지되었습니다: [" + mappedKey + "]. " +
                                    "허용된 키 목록: " + validKeys.toString());
            }
        }
    	
        // 파일확장자 확인하기 xlsx, xls 타입만 가능
        String fileName = file.getOriginalFilename();
        if (fileName == null || (!fileName.endsWith(".xlsx") && !fileName.endsWith(".xls"))) {
            throw new Exception("엑셀 파일만 업로드 가능합니다.");
        }

        // 데이터를 String 으로 받고 엑셀전용 insert DTO 만들고 그걸 Integer로 하는게 좋을가?
        List<Map<String, Object>> excelDataList = new ArrayList<Map<String, Object>>();
        InputStream is = file.getInputStream();
        Workbook workbook = WorkbookFactory.create(is);
        Sheet sheet = workbook.getSheetAt(0);
        
        
        // 행 갯수 제한 체크 (최대 1000건)
        // getLastRowNum()은 인덱스 기준이므로 0부터 시작합니다. 
        // 헤더가 0번 행, 데이터가 1번 행부터라면 총 행 수는 getLastRowNum()과 같습니다.
        int totalDataRows = sheet.getLastRowNum(); 
        if (totalDataRows > 1000) {
            workbook.close();
            throw new Exception("업로드 가능한 최대 행 수는 1000건입니다. (현재: " + totalDataRows + "건)");
        }
        
        // 데이터 존재 여부 체크
        if (totalDataRows < 1) {
            workbook.close();
            throw new Exception("업로드할 데이터가 없습니다.");
        }
        
        // 1. 엑셀의 첫 번째 줄(한글 헤더) 읽기
        Row headerRow = sheet.getRow(0);
        int columnCount = headerRow.getLastCellNum();
        
        // 엑셀 헤더의 위치(Index)별 영문 Key를 저장할 배열
        String[] targetKeys = new String[columnCount];
        
        // 각 헤더셀 이름이 일치한지 확인하면서 영문 키 벨류 값 넣기
        // 사용자계정, 사용자이름 이런식으로 헤더가 되어 있으면
        // userId, userNm 으로 매칭시킵니다.
        for (int i = 0; i < columnCount; i++) {
            String excelHeaderName = getCellValue(headerRow.getCell(i)).trim(); // 공백 제거 후 비교
            
            if (headerMap.containsKey(excelHeaderName)) {
                targetKeys[i] = headerMap.get(excelHeaderName);
            } else {
            	
                // [보완] 매핑되지 않은 헤더가 들어왔을 때 예외를 던지거나 로그를 남김
            	throw new Exception("엑셀의 [" + excelHeaderName + "] 헤더는 허용되지 않는 명칭입니다.");
            }
        }

        // 2. 데이터 행 반복하면서 데이터 저장 처리 
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Map<String, Object> rowMap = new HashMap<String, Object>();
            for (int colIdx = 0; colIdx < columnCount; colIdx++) {
            	
            	String value = getCellValue(row.getCell(colIdx));
                // 변환된 영문 Key(예: "userId")를 사용하여 데이터 저장
                rowMap.put(targetKeys[colIdx], value);
            }
            excelDataList.add(rowMap);
        }
        
        workbook.close();
        return excelDataList;
    }
    
    /**
     * 
     * 셀 타입별 문자열 추출 유틸리티
     * @author GD
     * @since 2026. 1. 26.
     * @param cell
     * @return 셀 타입별 문자열
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        String value = "";
        switch (cell.getCellType()) {
            case STRING: 
                value = cell.getStringCellValue(); 
                break;
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    value = cell.getDateCellValue().toString();
                } else {
                	// 지수 표기법 방지 (1234567.0 -> "1234567")
                	value = String.format("%.0f", cell.getNumericCellValue());
                }
                break;
            case BOOLEAN: 
                value = String.valueOf(cell.getBooleanCellValue()); 
                break;
            case FORMULA: 
                value = cell.getCellFormula(); 
                break;
            default: 
                value = "";
        }
        return value;
    }
    
    /**
     * * 엑셀 데이터를 특정 DTO 클래스 리스트로 반환
     * @author GD
     * @since 2026. 1. 26.
     * @param file
     * @param headerMap
     * @param validKeys
     * @param clazz 변환할 클래스 타입 <T> 반환할 DTO 타입 (예: AtchFileDto.class)
     * @return 엑셀 데이터가 담긴 DTO 리스트
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public <T> List<T> uploadExcelToDto(MultipartFile file, 
    								Map<String, String> headerMap, 
                                    List<String> validKeys, 
                                    Class<T> clazz) throws Exception {
        
        // 1. 기존에 만든 Map 기반 업로드 메서드 호출
        List<Map<String, Object>> dataList = this.uploadExcelFile(file, headerMap, validKeys);
        
        // 2. Map을 DTO로 변환 (Jackson ObjectMapper 활용)
        ObjectMapper mapper = new ObjectMapper();
        List<T> resultList = new ArrayList<>();
        
        for (Map<String, Object> map : dataList) {
            // mapper.convertValue가 Map의 Key와 DTO의 필드명을 매핑해줍니다.
            resultList.add(mapper.convertValue(map, clazz));
        }
        
        return resultList;
    }
    
    
    
    
    
    /**
     * 
     * 조회한 자료 엑셀다운로드
     * @author GD
     * @since 2026. 1. 26.
     * @param response		응답객체
     * @param fileName		다운로드될 파일명
     * @param headerMap		(LinkedHashMap) 헤더 매핑 (Key: 데이터의 영문키, Value: 엑셀에 노출할 한글명)
     * ex( userId, 사용자ID ) 
     * @param dataList		출력할 데이터 리스트 ( DTO 타입 )
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    @Override
    public void downloadExcel(HttpServletResponse response, 
    						String fileName, 
                            Map<String, String> headerMap, 
                            List<?> dataList) throws Exception {
    	
    	// DTO 리스트를 Map 리스트로 변환 (ObjectMapper 활용)
        ObjectMapper mapper = new ObjectMapper();
        List<Map<String, Object>> convertedList = new ArrayList<>();
        
        if (dataList != null) {
            for (Object obj : dataList) {
                
            	// 어떤 DTO든 Map<String, Object> 형태로 변환
                Map<String, Object> map = mapper.convertValue(obj, new TypeReference<Map<String, Object>>() {});
                convertedList.add(map);
            }
        }
    	
     // 데이터 존재 여부 및 키 정합성 체크 (변환된 리스트로 수행)
        if (!convertedList.isEmpty()) {
            
        	// headerMap은 LinkedHashMap 타입
        	Map<String, Object> firstRow = convertedList.get(0);
        	
        	// DB 컬럼명을 검사함
        	for (String key : headerMap.keySet()) {
                
        		if (!firstRow.containsKey(key)) {

        			// 개발자가 설정한 Key가 실제 DB 조회 결과(Map)에 없는 경우 예외 발생
        			 throw new Exception("엑셀 생성 오류: 헤더 설정된 Key [" + key + "]가 조회된 데이터에 존재하지 않습니다. " +
                             "조회된 컬럼: " + firstRow.keySet().toString());
                }
            }
        }
        
        
        // 1. 대용량 처리를 위한 SXSSF 워크북 생성 (메모리에 100행씩 유지)
        SXSSFWorkbook workbook = new SXSSFWorkbook(100);
        Sheet sheet = workbook.createSheet("Sheet1");
        
        // 2. 헤더 생성 (headerMap의 Value들을 첫 행에 출력)
        Row headerRow = sheet.createRow(0);
        int colIdx = 0;
        List<String> keyOrder = new ArrayList<String>(); // 데이터 추출 순서를 보장하기 위함
        
        for (Map.Entry<String, String> entry : headerMap.entrySet()) {
            Cell cell = headerRow.createCell(colIdx++);
            // 한글 헤더명
            cell.setCellValue(entry.getValue()); 
            // 영문 키 저장
            keyOrder.add(entry.getKey());        
        }

        // 3. 데이터 행 생성
        int rowIdx = 1;
        for (Map<String, Object> data : convertedList) {
        	
            Row row = sheet.createRow(rowIdx++);
            for (int i = 0; i < keyOrder.size(); i++) {
            	
                String key = keyOrder.get(i);
                String val = String.valueOf(data.get(key));
                
                // null 체크를 하여 빈 문자열로 처리
                // String val = (data.get(key) == null) ? "" : String.valueOf(data.get(key));
                
                row.createCell(i).setCellValue(val);
            }
        }

        // 4. 응답 설정 및 전송
        String encodedNm = UriUtils.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedNm + ".xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.dispose(); // 임시 파일 삭제
        workbook.close();
    }
    
}
