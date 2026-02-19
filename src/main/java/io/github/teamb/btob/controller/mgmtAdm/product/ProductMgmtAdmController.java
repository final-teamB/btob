package io.github.teamb.btob.controller.mgmtAdm.product;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductExcelService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/products")
public class ProductMgmtAdmController {

    private final ProductManagementService productManagementService;
    private final ProductExcelService productExcelService;
    private final ExcelService excelService;


    /**
     * 
     * [PAGE] 상품 관리 메인 (목록 + 등록/수정 모달 통합 페이지)
     * @author GD
     * @since 2026. 2. 9.
     * @param model
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @GetMapping("/list")
    public String productListPage(Model model) {
        model.addAttribute("pageTitle", "상품 관리");
        
        // 추가: 셀렉박스 데이터(유류종류, 원산지, 단위, 상태) 조회 및 전달
        model.addAttribute("selectBoxes", productManagementService.registerProductSelectBoxList());
        
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/product/productMgmtAdm.jsp");
        return "layout/layout";
    }
    /* =========================================================
       API 영역 (모달 및 리스트 비동기 통신용)
       ========================================================= */

    /**
     * 
     * [API] 셀렉박스 리스트만 별도로 필요할 경우 (비동기 호출용)
     * @author GD
     * @since 2026. 2. 9.
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @GetMapping("/api/select-boxes")
    @ResponseBody
    public ResponseEntity<Map<String, List<SelectBoxVO>>> getSelectBoxes() {
    	
        return ResponseEntity.ok(productManagementService.registerProductSelectBoxList());
    }
    
    

    /**
     * 
     * [API] 상품 목록 조회 (페이징 및 검색)
     * @author GD
     * @since 2026. 2. 9.
     * @param searchParams
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchConditionProductDTO>> getProductList(
            @RequestParam Map<String, Object> searchParams) throws Exception {
        
        log.info("상품 목록 조회 API 호출: {}", searchParams);
        PagingResponseDTO<SearchConditionProductDTO> response = productManagementService.getSearchConditionProductList(searchParams);
        return ResponseEntity.ok(response);
    }


    /**
     * 
     * [API] 상품 상세 정보 조회 (수정 모달 데이터 바인딩용)
     * @author GD
     * @since 2026. 2. 9.
     * @param fuelId
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @GetMapping("/api/{fuelId}")
    @ResponseBody
    public ResponseEntity<SearchDetailInfoProductDTO> getProductDetail(@PathVariable Integer fuelId) throws Exception {
        
        log.info("상품 상세 조회 API 호출 - ID: {}", fuelId);
        SearchDetailInfoProductDTO detail = productManagementService.getProductDetailInfo(fuelId);
        return ResponseEntity.ok(detail);
    }


    /**
     * 
     * [API] 상품 등록 (모달에서 호출)
     * 이제 이미지는 임시 폴더에 있으므로 JSON 데이터만 받습니다.
     * @author GD
     * @since 2026. 2. 9.
     * @param requestDTO
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @PostMapping(value = "/api/register")
    @ResponseBody
    public ResponseEntity<Integer> registerProduct(
            @RequestBody ProductRegisterRequestDTO requestDTO) throws Exception {

        log.info("상품 등록 API 호출 (임시파일 이동 방식): {}", requestDTO.getProductBase().getFuelNm());
        
        // 1. DTO에 담긴 mainTempNames, subTempNames를 사용하여 서비스 호출
        // 서비스에서 registerInternalImgFile을 호출하여 파일을 이동시킵니다.
        Integer result = productManagementService.registerProduct(requestDTO);
        
        return ResponseEntity.ok(result);
    }


    /**
     * 
     * [API] 상품 수정 (모달에서 호출)
     * @author GD
     * @since 2026. 2. 9.
     * @param fuelId
     * @param requestDTO
     * @param mainRemainNames
     * @param mainFiles
     * @param subRemainNames
     * @param subFiles
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @PostMapping(value = "/api/modify/{fuelId}", consumes = {"multipart/form-data"}) // PUT 대신 파일처리를 위해 POST 권장하는 경우도 있음
    @ResponseBody
    public ResponseEntity<Integer> modifyProduct(
            @PathVariable Integer fuelId,
            @RequestPart("productData") ProductModifyRequestDTO requestDTO,
            @RequestParam(value = "mainRemainNames", required = false) List<String> mainRemainNames,
            @RequestPart(value = "mainFiles", required = false) List<MultipartFile> mainFiles,
            @RequestParam(value = "subRemainNames", required = false) List<String> subRemainNames,
            @RequestPart(value = "subFiles", required = false) List<MultipartFile> subFiles) throws Exception {

        log.info("상품 수정 API 호출 - ID: {}", fuelId);
        requestDTO.getProductBase().setFuelId(fuelId);
        
        Integer result = productManagementService.modifyProduct(
                requestDTO, mainRemainNames, mainFiles, 
                subRemainNames, subFiles); 
        return ResponseEntity.ok(result);
    }

    /**
     * 
     * [API] 상품 삭제/미사용 처리
     * @author GD
     * @since 2026. 2. 9.
     * @param requestDTO
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @PutMapping("/api/unuse")
    @ResponseBody
    public ResponseEntity<Integer> unUseProduct(@RequestBody ProductUnUseRequestDTO requestDTO) throws Exception {
        
        log.info("상품 미사용 처리 API 호출 - ID: {}", requestDTO.getFuelId());
        Integer result = productManagementService.unUseProduct(requestDTO);
        return ResponseEntity.ok(result);
    }
    
    /**
     * 
     * 상품 관리 엑셀 일괄등록 양식 다운로드
     * @author GD
     * @since 2026. 2. 9.
     * @param response
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @GetMapping("/download/template")
    public void downloadTemplate(HttpServletResponse response) {
        try {
        	productExcelService.productTempDownload(response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    /**
     * 
     * 상품 엑셀 일괄 업로드 실행
     * @author GD
     * @since 2026. 2. 9.
     * @param file 엑셀 파일 (MultipartFile)
     * @return 성공/실패 건수 및 내역
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 9.  GD       최초 생성
     */
    @PostMapping("/api/upload/excel")
    public ResponseEntity<Map<String, Object>> uploadExcel(@RequestParam("file") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 1. 파일 유효성 검사
            if (file == null || file.isEmpty()) {
                response.put("success", false);
                response.put("message", "업로드할 엑셀 파일을 선택해주세요.");
                return ResponseEntity.badRequest().body(response);
            }

            // 2. 엑셀 프로세스 실행 (서비스 호출)
            ExcelUploadResultDTO<ProductUploadExcelDTO> result = productExcelService.processUpload(file);

            // 3. 결과 정보 구성
            response.put("success", true);
            response.put("totalCount", result.getTotalCount());     // 전체 행
            response.put("successCount", result.getSuccessCount()); // 저장 성공
            response.put("failCount", result.getFailCount());       // 저장 실패
            response.put("failList", result.getFailList());         // 실패 상세(행번호, 에러메시지)
            
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "엑셀 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    /**
     * 
     * 엑셀 업로드 실패 내역 및 다운로ㅡ 기능
     * @author GD
     * @since 2026. 2. 10.
     * @param response
     * @param failListJson
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @PostMapping("/api/download/fail-report")
    public void downloadFailReport(HttpServletResponse response, @RequestParam("failListJson") String failListJson) {
        try {
            // 1. JSON 문자열을 객체 리스트로 변환
            ObjectMapper mapper = new ObjectMapper();
            List<ExcelUploadResultDTO.ExcelFailDetail> failList = mapper.readValue(
                failListJson, 
                new TypeReference<List<ExcelUploadResultDTO.ExcelFailDetail>>() {}
            );

            // 2. [추가] 업로드 시 사용했던 것과 동일한 headerMap 정의
            // 이 맵은 업로드 로직(uploadAndSave)을 호출할 때 썼던 맵과 구성이 같아야 합니다.
            Map<String, String> headerMap = new LinkedHashMap<>();
            headerMap.put("유류명칭", "fuelNm");
            headerMap.put("유류종류코드", "fuelCatCd");
            headerMap.put("원산지국가코드", "originCntryCd");
            headerMap.put("기준단가", "baseUnitPrc");
            headerMap.put("현재재고량", "currStockVol");
            headerMap.put("안전재고량", "safeStockVol");
            headerMap.put("용량단위코드", "volUnitCd");
            headerMap.put("재고상태코드", "itemSttsCd");
            headerMap.put("등록자ID", "regId");
            headerMap.put("사용여부", "useYn");
            headerMap.put("API비중", "apiGrv");
            headerMap.put("유황함량", "sulfurPCnt");
            headerMap.put("인화점", "flashPnt");
            headerMap.put("점도", "viscosity");
            headerMap.put("15도밀도", "density15c");
            headerMap.put("상세내용", "fuelMemo");
            headerMap.put("메인이미지명", "mainFileNm"); // 엑셀헤더 "메인이미지명" -> DTO "mainFileNm"
            headerMap.put("서브이미지명", "subFileNm"); // 엑셀헤더 "서브이미지명" -> DTO "subFileNm"

            // 3. 수정된 서비스 호출 (headerMap 인자 추가)
            excelService.downloadFailReport(response, failList, headerMap);
            
        } catch (Exception e) {
            log.error("실패 리포트 다운로드 중 오류 발생", e);
        }
    }

    /**
     * 
     * 상품 목록 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 10.
     * @param params 검색 조건 (fuelNm, itemSttsCd 등)
     * @param response
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @GetMapping("/download/excel")
    public void downloadProductExcel(@RequestParam Map<String, Object> params, HttpServletResponse response) {
        try {
        	
            // 서비스 호출 (조회부터 엑셀 생성까지 처리)
        	productExcelService.downloadProductExcel(response, params);
            
        } catch (Exception e) {
        	
            log.error("상품 목록 엑셀 다운로드 중 오류 발생", e);
            // 에러 발생 시 사용자에게 알림을 줄 수 있도록 처리 (예: 스크립트 출력 등)
            response.setContentType("text/html; charset=UTF-8");
            try {
            	
                response.getWriter().write("<script>alert('엑셀 다운로드 중 오류가 발생했습니다.'); history.back();</script>");
            } catch (IOException ioException) {
            	
                ioException.printStackTrace();
            }
        }
    }
}