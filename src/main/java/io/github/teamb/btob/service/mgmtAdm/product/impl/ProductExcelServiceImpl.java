package io.github.teamb.btob.service.mgmtAdm.product.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.excel.ExcelUploadResult;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.mapper.mgmtAdm.ProductMgmtAdmMapper;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductExcelService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductExcelServiceImpl implements ProductExcelService {
	
	// 엑셀 모듈
	private final ExcelService excelService;
	// 추출 데이터
	private final ProductMgmtAdmMapper productMgmtAdmMapper;
	
	
	/**
	 * 
	 * 업로드 양식 다운로드 ( 서버에 저장한 업로드 양식 파일 )
	 * @author GD
	 * @since 2026. 2. 3.
	 * @param response
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 3.  GD       최초 생성
	 */
	@Override
	public void ProductTempDownload(HttpServletResponse response) throws Exception {

		// 1. 파일명 설정 ( 업로드 양식 파일명 )
		String fileName = "고정양식테스트123.xlsx";
		
		// 2. 다운로드 실행
		excelService.downloadExcelTemplate(response, fileName);
	}

	
	/**
	 * 
	 * 엑셀 파일 일괄 업로드
	 * 사용 시 주의 사항 Transaction 걸면 안됨
	 * @author GD
	 * @since 2026. 2. 3.
	 * @param file ( 업로드 할 엑셀 자료 파일 )
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 3.  GD       최초 생성
	 */
	@Override
	public ExcelUploadResult<ProductUploadExcelDTO> processUpload(MultipartFile file) throws Exception {
		
		// 1. 실제로 사용할 정확한 영문 Key 목록 (White List)
        List<String> validKeys = Arrays.asList(
        		 "fuelCd", "fuelNm", "fuelCatCd", "originCntryCd", 
        		    "baseUnitPrc", "currStockVol", "safeStockVol", 
        		    "volUnitCd", "itemSttsCd", "regId", "useYn",
        		    "apiGrv", "sulfurPCnt", "flashPnt", "viscosity", "density15c");

        // 2. 한글-영문 매핑 정보
        // 엑셀파일하고 동일하게 맞춰야함
        Map<String, String> myHeader = new HashMap<String, String>();
        myHeader.put("유류코드", "fuelCd");
        myHeader.put("유류명칭", "fuelNm");
        myHeader.put("유류종류코드", "fuelCatCd");
        myHeader.put("원산지국가코드", "originCntryCd");
        myHeader.put("기준단가", "baseUnitPrc");
        myHeader.put("현재재고량", "currStockVol");
        myHeader.put("안전재고량", "safeStockVol");
        myHeader.put("용량단위코드", "volUnitCd");
        myHeader.put("재고상태코드", "itemSttsCd");
        myHeader.put("등록자ID", "regId");
        myHeader.put("사용여부", "useYn");
        myHeader.put("API비중", "apiGrv");
        myHeader.put("유황함량", "sulfurPCnt");
        myHeader.put("인화점", "flashPnt");
        myHeader.put("점도", "viscosity");
        myHeader.put("15도밀도", "density15c");
        
        // 필수로 들어가야하는 값 ( 필수 항목 정의 == null 값 검증 부분임)
        List<String> requiredKeys = List.of("refTypeCd", 
								        		"refId", 
								        		"orgFileNm", 
								        		"strFileNm", 
								        		"filePath", 
								        		"fileExt", 
								        		"updDtime" );  
								        
        // 3. [수정 핵심] 공통 모듈의 uploadAndSave 호출
	    // - dtoList를 직접 받아서 for문을 돌리는 대신, saver 로직(람다식)을 넘깁니다.
	    ExcelUploadResult<ProductUploadExcelDTO> result = excelService.uploadAndSave(
	            file, 
	            myHeader, 
	            validKeys, 
	            requiredKeys, 
	            ProductUploadExcelDTO.class,					// 엑셀 추출할 양식의 DTO 
	            // dto -> atchFileMapper.insertFile(dto) 		// 각 행마다 실행될 저장 로직
	            // 업데이트 테이블이 2개 이상인 경우 하단 방식으로 진행 DTO 참조요망
	            dto -> { 
	            	// 1. 기본 정보 변환 및 저장
	                InsertProductDTO base = dto.toBaseDTO();
	                productMgmtAdmMapper.insertProductAdm(base); 
	                
	                // 2. 상세 정보 변환
	                InsertDetailInfoProductDTO detail = dto.toDetailDTO();
	                
	                // 3. FK 연결 (기본 테이블에서 생성된 ID를 상세 DTO에 세팅)
	                detail.setFuelId(base.getFuelId()); 
	                
	                // 4. 상세 정보 저장
	                productMgmtAdmMapper.insertProductDetailInfoAdm(detail);
	            }
	    );

        // 4. 결과 반환 (컨트롤러에서 이 result를 받아 화면에 성공/실패 건수를 뿌려줍니다.)
   		return result;
	}

	/**
	 * 
	 * 상품 조회 자료 엑셀 다운로드
	 * @author GD
	 * @since 2026. 2. 3.
	 * @param response 
	 * @param params ( 검색 조건식 )
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 3.  GD       최초 생성
	 */
	@Override
	public void downloadProductExcel(HttpServletResponse response, Map<String, Object> params) throws Exception {
		
			// 1. DB에서 데이터 조회
			List<SearchConditionProductDTO> dataList = productMgmtAdmMapper.selectProductSearchConditionListAdm(params);
			
			// 2. 엑셀 헤더 설정 (LinkedHashMap을 써야 넣은 순서대로 엑셀 컬럼이 생깁니다)
			Map<String, String> headerMap = new LinkedHashMap<String, String>();
			headerMap.put("rownm", "순번");
			headerMap.put("fuelId", "유류ID");
			headerMap.put("fuelCd", "유류코드");
			headerMap.put("fuelNm", "유류명칭");
			headerMap.put("fuelCatNm", "유류종류");
			headerMap.put("originCntryNm", "원산지국가");
			headerMap.put("baseUnitPrc", "기준단가");
			headerMap.put("currStockVol", "현재재고");
			headerMap.put("safeStockVol", "안전재고");
			headerMap.put("volUnitNm", "용량단위");
			headerMap.put("itemSttsNm", "재고상태");
			headerMap.put("regDtime", "등록일시");
			headerMap.put("updDtime", "수정일시");
			headerMap.put("useYn", "사용여부");
			
			// 3. 파일명 설정 
			String fileName = "상품_목록_리스트_" + System.currentTimeMillis();
			
			// 4. 공통 모듈 호출
			excelService.downloadExcel(response, fileName, headerMap, dataList);
	}
}
