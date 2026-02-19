package io.github.teamb.btob.service.excel.iml;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.service.excel.ExcelService;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class ExcelServiceImpl implements ExcelService {
	
	@Value("${file.upload.path.excel}")
    private String excelUploadPath; // D:/upload/excel 경로가 주입됨

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
    	
    	// --- [추가] 파일 물리 저장 로직 시작 ---
    	if (file != null && !file.isEmpty()) {
            String originalFileName = file.getOriginalFilename();
            String dateStr = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
            String serverFileName = dateStr + "_" + java.util.UUID.randomUUID().toString().substring(0, 8) + "_" + originalFileName;
            
            java.io.File dir = new java.io.File(excelUploadPath);
            if (!dir.exists()) dir.mkdirs();

            java.io.File targetFile = new java.io.File(dir, serverFileName);
            
            // [중요] transferTo(targetFile) 대신 아래 코드를 사용하세요.
            try (InputStream is = file.getInputStream();
                 java.io.OutputStream os = new java.io.FileOutputStream(targetFile)) {
                org.springframework.util.FileCopyUtils.copy(is, os);
            }
            
            System.out.println("엑셀 업로드 파일 저장 완료: " + targetFile.getAbsolutePath());
        }
        // --- [추가] 파일 물리 저장 로직 종료 ---
    	
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
        // 에러 메시지용 한글 이름 저장
        String[] headerNames = new String[columnCount];
        
        // 각 헤더셀 이름이 일치한지 확인하면서 영문 키 벨류 값 넣기
        // 사용자계정, 사용자이름 이런식으로 헤더가 되어 있으면
        // userId, userNm 으로 매칭시킵니다.
        for (int i = 0; i < columnCount; i++) {
            
        	String excelHeaderName = getCellValue(headerRow.getCell(i)).trim(); // 공백 제거 후 비교
            
        	// 한글 헤더명 보관
            headerNames[i] = excelHeaderName; 
            
            // 헤더명 비교처리 후 영문 키 저장
            if (headerMap.containsKey(excelHeaderName)) {
                targetKeys[i] = headerMap.get(excelHeaderName);
            } else {
            	
                // 매핑되지 않은 헤더가 들어왔을 때 예외를 던지거나 로그를 남김
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

                	// ISO 표준 포맷으로 변환 , LocalDateTime이 기본적으로 읽을 수 있는 yyyy-MM-ddTHH:mm:ss 형식 
                	Date date = cell.getDateCellValue();
                    value = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
                    //value = cell.getDateCellValue().toString();
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
     * @param requiredKeys
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
                                    List<String> requiredKeys,
                                    Class<T> clazz) throws Exception {
    	
    	// 1. 엑셀 데이터를 Map 리스트로 추출
        List<Map<String, Object>> dataList = this.uploadExcelFile(file, headerMap, validKeys);
        
        // 2. Map을 DTO로 변환 (Jackson ObjectMapper 활용)
        ObjectMapper mapper = new ObjectMapper();
        // Java 8 date/time 모듈 등록 Convert 오류남
        mapper.registerModule(new JavaTimeModule());
        
        List<T> resultList = new ArrayList<>();
        
        for (int i = 0; i < dataList.size(); i++) {
            
        	Map<String, Object> map = dataList.get(i);
            int rowNum = i + 2; // 엑셀 행 번호 (헤더 1행 제외하고 2행부터 데이터)

            // 2. 필수값(Required Keys) 검증
            if (requiredKeys != null) {
            	
                for (String reqKey : requiredKeys) {
                	
                    Object val = map.get(reqKey);
                    
                    if (val == null || val.toString().trim().isEmpty()) {
                    	
                        // 한글 헤더명을 찾아서 메시지에 노출 (가독성 향상)
                        String hNm = findKoreanHeader(headerMap, reqKey);
                        throw new Exception(rowNum + "행의 [" + hNm + "] 항목은 필수 입력값입니다.");
                    }
                }
            }

            // 3. DTO 변환 및 타입 검증 (숫자, 날짜 등 형식 오류 캐치)
            try {
                resultList.add(mapper.convertValue(map, clazz));
            } catch (IllegalArgumentException e) {
                // Jackson이 던지는 에러 메시지를 분석하여 사용자용 메시지로 변환
                //String errorMsg = e.getMessage();
                //throw new Exception(rowNum + "행의 데이터 형식이 올바르지 않습니다. (입력값 확인 필요)"); 
            	// 임시주석함
                
                // 디버깅을 위해 콘솔에 상세 내용을 찍습니다.
                System.err.println("=== 엑셀 변환 오류 발생 ===");
                System.err.println("행 번호: " + rowNum);
                System.err.println("원인 데이터(Map): " + map); // 여기서 어떤 컬럼이 문제인지 보입니다.
                System.err.println("에러 메시지: " + e.getMessage());
                System.err.println("===========================");

                // 사용자에게는 좀 더 친절하게 어떤 필드가 문제인지 알려주면 좋습니다.
                String errorMsg = e.getMessage();
                // 만약 에러 메시지에 특정 필드명이 포함되어 있다면 추출해서 보여줄 수도 있습니다.
                throw new Exception(rowNum + "행의 데이터 형식이 올바르지 않습니다. 상세원인: " + errorMsg);
            }
        }
        
        return resultList;
    }
    
    /**
     * 
     * 엑셀 데이터를 DB에 저장하고 성공/실패 결과를 반환
     * @author GD
     * @since 2026. 2. 3.
     * @param <T>
     * @param file	업로드 엑셀 파일
     * @param headerMap	// 목록 헤더
     * @param validKeys	// 헤더에 맞는 컬럼
     * @param requiredKeys // 필수로 들어가야하는 컬럼
     * @param clazz	// 변환할 클래스 타입 <T> 반환할 DTO 타입 // 엑셀 업로드 양식 DTO (예: AtchFileDto.class)
     * @param saver 실제 DB에 저장할 로직 (매퍼의 insert 메서드 등)
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 3.  GD       최초 생성
     */
    public <T> ExcelUploadResultDTO<T> uploadAndSave(
            MultipartFile file, 
            Map<String, String> headerMap, 
            List<String> validKeys, 
            List<String> requiredKeys, 
            Class<T> clazz,
            Consumer<T> saver) {

        // 1. 변환된 리스트를 가져오는 대신, 원본 데이터(Map) 리스트만 먼저 가져옵니다.
        List<Map<String, Object>> dataList;
        try {
            dataList = this.uploadExcelFile(file, headerMap, validKeys);
        } catch (Exception e) {
            throw new RuntimeException("엑셀 파일 읽기 실패: " + e.getMessage());
        }

        List<T> successList = new ArrayList<>();
        List<ExcelUploadResultDTO.ExcelFailDetail> failList = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());

        // 2. 루프 내부에서 검증, 변환, 저장을 모두 처리합니다.
        for (int i = 0; i < dataList.size(); i++) {
            Map<String, Object> map = dataList.get(i);
            int rowNum = i + 2;

            try {
                // A. 필수값 검증 (uploadExcelToDto에 있던 로직을 여기로 가져옴)
                if (requiredKeys != null) {
                    for (String reqKey : requiredKeys) {
                        Object val = map.get(reqKey);
                        if (val == null || val.toString().trim().isEmpty()) {
                            String hNm = findKoreanHeader(headerMap, reqKey);
                            throw new Exception("[" + hNm + "] 항목은 필수값입니다.");
                        }
                    }
                }

                // B. DTO 변환
                T dto;
                try {
                    dto = mapper.convertValue(map, clazz);
                } catch (Exception e) {
                    throw new Exception("데이터 형식이 올바르지 않습니다.");
                }

                // C. 실제 저장 실행 (람다 호출)
                saver.accept(dto); 
                
                // 저장 성공 시 리스트 추가
                successList.add(dto);

            } catch (Exception e) {
                // [중요] 개별 행에서 발생한 모든 에러(검증 실패, 변환 실패, DB 에러)를 여기서 잡습니다.
                // 에러가 발생해도 루프는 멈추지 않고 다음 i로 넘어갑니다.
            	failList.add(new ExcelUploadResultDTO.ExcelFailDetail(rowNum, e.getMessage(), map));
            }
        }

        return ExcelUploadResultDTO.<T>builder()
                .totalCount(dataList.size())
                .successCount(successList.size())
                .failCount(failList.size())
                .successList(successList)
                .failList(failList)
                .build();
    }
    
    /**
     * 
     * 실패 내역 전용 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 3.
     * @param response
     * @param failList 실패 상세 리스트 (ExcelFailDetail)
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 3.  GD       최초 생성
     */
    @Override
    public void downloadFailReport(HttpServletResponse response, 
    			List<ExcelUploadResultDTO.ExcelFailDetail> failList,
    			Map<String, String> headerMap) throws Exception {
        
        SXSSFWorkbook workbook = new SXSSFWorkbook(100);
        Sheet sheet = workbook.createSheet("실패리포트");

        // 1. 순서를 보장하기 위해 headerMap의 Value(영문키) 리스트를 미리 추출
        // 컨트롤러에서 LinkedHashMap으로 주었기 때문에 이 리스트는 순서가 고정됩니다.
        List<String> orderedEngKeys = new ArrayList<>(headerMap.values());
        // 영문키에 대응하는 한글명을 찾기 위한 맵 (headerMap 자체가 {한글:영문}이므로 역방향 필요)
        Map<String, String> reverseHeader = new HashMap<>();
        headerMap.forEach((k, v) -> reverseHeader.put(v, k));
        
        // 2. 헤더 생성 (Row 0)
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("엑셀 행 번호");
        headerRow.createCell(1).setCellValue("에러 사유");
        
        // 정의된 순서(orderedEngKeys)대로 헤더 컬럼 생성
        for (int i = 0; i < orderedEngKeys.size(); i++) {
            String engKey = orderedEngKeys.get(i);
            String korName = reverseHeader.get(engKey); 
            headerRow.createCell(i + 2).setCellValue(korName != null ? korName : "");
        }

        // 3. 데이터 생성
        int rowIdx = 1;
        for (ExcelUploadResultDTO.ExcelFailDetail fail : failList) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(fail.getRowNum());
            row.createCell(1).setCellValue(fail.getErrorMsg());
            
            // 정의된 순서(orderedEngKeys)대로 데이터 바인딩
            for (int j = 0; j < orderedEngKeys.size(); j++) {
                String engKey = orderedEngKeys.get(j);
                Object val = fail.getRowData().get(engKey);
                row.createCell(j + 2).setCellValue(val != null ? val.toString() : "");
            }
        }

        String fileName = UriUtils.encode("업로드_실패_리포트", StandardCharsets.UTF_8);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xlsx\"");

        workbook.write(response.getOutputStream());
        workbook.dispose();
        workbook.close();
    }
    
    /**
     * 
     * 엑셀 데이터 검증 체크 ( 데이터 타입, 필수값 체크 ) 
     * @author GD
     * @since 2026. 1. 27.
     * @param headerMap
     * @param engKey
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 27.  GD       최초 생성
     */
    private String findKoreanHeader(Map<String, String> headerMap, String engKey) {
    	
        return headerMap.entrySet().stream()
                .filter(entry -> entry.getValue().equals(engKey))
                .map(Map.Entry::getKey)
                .findFirst()
                .orElse(engKey);
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
        // Java 8 date/time 모듈 등록 Convert 오류남
        mapper.registerModule(new JavaTimeModule());
        
        // 날짜를 [2026, 2, 10...] 처럼 숫자로 쪼개지 않게 설정
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        
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
             // [추가 포인트 2] 데이터 변환 및 날짜 포맷팅
                Object rawValue = data.get(key);
                String val = "";
                
                if (rawValue != null) {
                    val = String.valueOf(rawValue);
                    
                    // ISO 날짜 형식(2026-02-10T10:09:57)일 경우 T를 공백으로 치환
                    // 위에서 설정을 껐기 때문에 rawValue가 문자열로 넘어옵니다.
                    if (val.contains("T") && val.length() >= 19) {
                        val = val.replace("T", " ");
                    }
                }
                
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
