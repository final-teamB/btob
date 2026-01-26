package io.github.teamb.btob.jprtest.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import io.github.teamb.btob.jprtest.dto.AtchFileDto;
import io.github.teamb.btob.jprtest.mapper.AtchFileMapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class ExcelTestService  {
	
	// 엑셀 모듈
    private final ExcelService excelService; 
    // 추출할 데이터
    private final AtchFileMapper atchFileMapper;

    /**
     * 양식 다운로드
     */
    public void processTempDownload(HttpServletResponse response) throws Exception {
    	
    	String fileName = "고정양식테스트123.xlsx";
    	excelService.downloadExcelTemplate(response, fileName);
    }
    
    
    /**
     * 
     * 엑셀 파일 일괄 업로드
     * @author GD
     * @since 2026. 1. 26.
     * @param file		업로드 할 엑셀 자료 파일
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 1. 26.  GD       최초 생성
     */
    public void processUpload(MultipartFile file) throws Exception {

    	// 1. 실제로 사용할 정확한 영문 Key 목록 (White List)
        List<String> validKeys = Arrays.asList(
        		"refTypeCd", 
	            "refId",
	            "orgFileNm", 
	            "strFileNm", 
	            "filePath", 
	            "fileExt", 
	            "fileSize");

        // 2. 한글-영문 매핑 정보
        // 엑셀파일하고 동일하게 맞춰야함
        Map<String, String> myHeader = new HashMap<String, String>();
        myHeader.put("참조유형", "refTypeCd");
        myHeader.put("참조대상", "refId");
        myHeader.put("원래파일명", "orgFileNm");
        myHeader.put("변환파일명", "strFileNm"); 
        myHeader.put("파일경로", "filePath"); 
        myHeader.put("파일확장자", "fileExt"); 
        myHeader.put("파일사이즈", "fileSize"); 
        
        // 3. 공통 모듈 호출 (검증 리스트 추가 전달)
        List<AtchFileDto> dtoList = excelService.uploadExcelToDto(
                file, myHeader, validKeys, AtchFileDto.class
            );

        // 데이터 저장
        for (AtchFileDto dto : dtoList) {
                atchFileMapper.insertFile(dto);
        }
    }
    
    
    
    /**
     * 엑셀 다운로드 실행 로직
     */
    public void downloadUserExcel(HttpServletResponse response, Map<String, Object> param) throws Exception {

    	// 1. DB에서 데이터 조회
    	List<AtchFileDto> dataList = atchFileMapper.selectFileListByRef(param);

        // 2. 엑셀 헤더 설정 (LinkedHashMap을 써야 넣은 순서대로 엑셀 컬럼이 생깁니다)
        Map<String, String> headerMap = new LinkedHashMap<String, String>();
        headerMap.put("refTypeCd", "참조유형");
        headerMap.put("refId", "참조대상");
        headerMap.put("orgFileNm", "원래파일명");
        headerMap.put("strFileNm", "변환파일명"); 
        headerMap.put("filePath", "파일경로"); 
        headerMap.put("fileExt", "파일확장자"); 
        headerMap.put("fileSize", "파일사이즈");

        // 3. 파일명 설정 
        String fileName = "자료_엑셀_다운로드_테스트" + System.currentTimeMillis();

        // 4. 공통 모듈 호출
        excelService.downloadExcel(response, fileName, headerMap, dataList);
    }

}
