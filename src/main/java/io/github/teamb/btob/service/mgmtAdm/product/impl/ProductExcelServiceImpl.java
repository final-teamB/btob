package io.github.teamb.btob.service.mgmtAdm.product.impl;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertDetailInfoProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.mapper.mgmtAdm.ProductMgmtAdmMapper;
import io.github.teamb.btob.service.attachfile.FileService;
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
	// 첨부파일 이미지
	private final FileService fileService;
	
	// 파일 이미지 미리보기 임시저장폴더
    @Value("${file.upload.path.temp}")
    private String imgTempPath;
	
	// 루트 경로 (공통)
    @Value("${file.upload.root}")
    private String rootPath;
	
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
	public void productTempDownload(HttpServletResponse response) throws Exception {

		// 1. 파일명 설정 ( 업로드 양식 파일명 )
		String fileName = "상품_관리_일괄업로드_양식.xlsx";
		
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
	public ExcelUploadResultDTO<ProductUploadExcelDTO> processUpload(MultipartFile file) throws Exception {
		
		// 이 작업에서 사용할 임시 경로 설정 (예: 사용자별 혹은 세션별 폴더)
		// 이미지 일괄업로드 첨부에서만 사용합니다. 일반적인 데이터 일괄업로드시에는 해당 변수 선언 안해도 됩니다.
	    //String currentTempPath = imgTempPath;
		
		// 1. 실제로 사용할 정확한 영문 Key 목록 (White List)
        List<String> validKeys = Arrays.asList( 
									        	"fuelNm", 
									        	"fuelCatCd", 
									        	"originCntryCd", 
									        	"baseUnitPrc", 
									        	"currStockVol", 
									        	"safeStockVol", 
									        	"volUnitCd", 
									        	"itemSttsCd", 
									        	"regId", 
									        	"useYn",
									        	"apiGrv", 
									        	"sulfurPCnt", 
									        	"flashPnt", 
									        	"viscosity", 
									        	"density15c",
									        	"fuelMemo",
									        	"mainFileNm",
									        	"subFileNm");

        // 2. 한글-영문 매핑 정보
        // 엑셀파일하고 동일하게 맞춰야함
        Map<String, String> myHeader = new HashMap<String, String>();
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
        myHeader.put("상세내용", "fuelMemo");
        
        myHeader.put("메인이미지명", "mainFileNm"); // 엑셀헤더 "메인이미지명" -> DTO "mainFileNm"
        myHeader.put("서브이미지명", "subFileNm"); // 엑셀헤더 "서브이미지명" -> DTO "subFileNm"
        
        // 필수로 들어가야하는 값 ( 필수 항목 정의 == null 값 검증 부분임)
        List<String> requiredKeys = List.of( 
								        	"fuelNm", 
								        	"fuelCatCd", 
								        	"originCntryCd", 
								        	"baseUnitPrc", 
								        	"currStockVol", 
								        	"safeStockVol", 
								        	"volUnitCd", 
								        	"itemSttsCd", 
								        	"regId", 
								        	"useYn",
								        	"apiGrv", 
								        	"sulfurPCnt", 
								        	"flashPnt", 
								        	"viscosity", 
								        	"density15c");  

        // 카테고리별 시퀀스를 관리할 맵 (uploadAndSave 실행 직전에 선언)
        Map<String, Integer> sequenceMap = new HashMap<>();
        
        // 3. [수정 핵심] 공통 모듈의 uploadAndSave 호출
	    ExcelUploadResultDTO<ProductUploadExcelDTO> result = excelService.uploadAndSave(
	            file, 
	            myHeader, 
	            validKeys, 
	            requiredKeys, 
	            ProductUploadExcelDTO.class,					// 엑셀 추출할 양식의 DTO 
	            // dto -> atchFileMapper.insertFile(dto) 		// 각 행마다 실행될 저장 로직
	            // 업데이트 테이블이 2개 이상인 경우 하단 방식으로 진행 DTO 참조요망
	            dto -> { 
	            	try {
	            		
	                    // 1. 기본 정보 저장
	                    InsertProductDTO base = dto.toBaseDTO();
	                    
	                    // 유류코드 자동생성 fuel_cd
	                    // --- [유류코드 자동생성 로직 핵심] ---
	                    String fuelCatCd = base.getFuelCatCd();
	                    String fuelCntryCd = base.getOriginCntryCd();
	                    // 맵에서 사용할 키 생성 (예: "GASOLINE_KR")
	                    String comboKey = fuelCatCd + "_" + fuelCntryCd;
	                    
	                    int objId;
	                    
	                    if (!sequenceMap.containsKey(comboKey)) {
	                        // A. 이 조합을 처음 만났다면 DB에서 현재 개수 + 1을 가져옴
	                        objId = productMgmtAdmMapper.selectAutoObjId(base);
	                        sequenceMap.put(comboKey, objId);
	                    } else {
	                        // B. 이미 맵에 있다면 DB 조회 없이 메모리에 있는 번호 + 1
	                        objId = sequenceMap.get(comboKey) + 1;
	                        sequenceMap.put(comboKey, objId);
	                    }
	                    
	                    int year = LocalDate.now().getYear(); 
	                    String fuelCd = year + "-" + fuelCatCd + "-" + fuelCntryCd + "-" + objId;
	                    base.setFuelCd(fuelCd); // 생성된 유니크 코드를 base에 세팅
	                    // --- [유류코드 자동생성 로직 종료] ---

	                    productMgmtAdmMapper.insertProductAdm(base); 
	                    Integer fuelId = base.getFuelId();
	                    
	                    System.out.println("생성된 상품 ID (fuelId): " + fuelId);
	                    
	                    // 2. 상세 정보 저장
	                    InsertDetailInfoProductDTO detail = dto.toDetailDTO();
	                    detail.setFuelId(fuelId); 
		                 // [수정 포인트] 상세 정보에도 useYn 값이 필요하므로 엑셀 DTO에서 가져와 세팅합니다.
		                 // dto.getUseYn()이 없다면 base.getUseYn() 혹은 기본값 "Y"를 넣어주세요.
		                 detail.setUseYn(dto.getUseYn() != null ? dto.getUseYn() : "Y"); 
		                 // regId도 누락될 수 있으니 확인 후 세팅
		                 detail.setRegId(dto.getRegId());
	                    
	                    productMgmtAdmMapper.insertProductDetailInfoAdm(detail);
	                    
	                    // 이미지 일괄업로드 시에만 사용합니다. 
	                    // 일반 데이터 업로드 시에는 2번사항까지만 진행 
	                    // 3. 메인 이미지 등록
	                    if (dto.getMainFileNm() != null && !dto.getMainFileNm().isEmpty()) {
	                        AtchFileDto mainDto = dto.toAtchFileDTO(fuelId, "PRODUCT_M", dto.getMainFileNm());
	                        fileService.registerInternalImgFile(mainDto);
	                    }

	                    // 4. 서브 이미지 등록
	                    if (dto.getSubFileNm() != null && !dto.getSubFileNm().isEmpty()) {
	                        AtchFileDto subDto = dto.toAtchFileDTO(fuelId, "PRODUCT_S", dto.getSubFileNm());
	                        fileService.registerInternalImgFile(subDto);
	                    }
	                } catch (Exception e) {
	                	
	                    // 중요: 여기서 RuntimeException을 던져야 공통 모듈의 catch 블록으로 갑니다.
	                    // 공통 모듈은 이 에러를 잡아서 failList에 넣고 '다음 행'으로 넘어갑니다.
	                	// [핵심] 실패 원인을 콘솔에 명확히 찍어줍니다.
	                    System.err.println("!!! 엑셀 행 저장 실패 원인 !!!");
	                    //e.printStackTrace(); 
	                    throw new RuntimeException(e.getMessage());
	                }
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
