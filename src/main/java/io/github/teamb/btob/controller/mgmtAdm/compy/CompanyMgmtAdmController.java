package io.github.teamb.btob.controller.mgmtAdm.compy;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.github.teamb.btob.controller.mgmtAdm.product.ProductMgmtAdmController;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.CompyRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.CompyUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchConditionCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchDetailInfoCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.UpdateCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.compy.CompanyExcelService;
import io.github.teamb.btob.service.mgmtAdm.compy.CompanyManagementService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductExcelService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/company")
public class CompanyMgmtAdmController {
	
	private final CompanyManagementService companyManagementService;
	private final CompanyExcelService companyExcelService;
	private final ExcelService excelService;

	
	/**
     * 
     * [PAGE] 회사 관리 메인 (목록 + 등록/수정 모달 통합 페이지)
     * @author GD
     * @since 2026. 2. 20.
     * @param model
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @GetMapping("/list")
    public String companyListPage(Model model) {
        model.addAttribute("pageTitle", "회사 관리");
        
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/company/companyMgmtAdm.jsp");
        return "layout/layout";
    }


    /**
     * 
     * [API] 회사 목록 조회 (페이징 및 검색)
     * @author GD
     * @since 2026. 2. 20.
     * @param searchParams
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchConditionCompyDTO>> getCompanyList(
            @RequestParam Map<String, Object> searchParams) throws Exception {
        
        log.info("회사 목록 조회 API 호출: {}", searchParams);
        PagingResponseDTO<SearchConditionCompyDTO> response = companyManagementService.getSearchConditionCompyList(searchParams);
        return ResponseEntity.ok(response);
    }


    /**
     * 
     * [API] 회사 상세 정보 조회 (수정 모달 데이터 바인딩용)
     * @author GD
     * @since 2026. 2. 20.
     * @param companySeq
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @GetMapping("/api/{companySeq}")
    @ResponseBody
    public ResponseEntity<SearchDetailInfoCompyDTO> getComapnyDetail(@PathVariable Integer companySeq) throws Exception {
        
        log.info("회사 상세 조회 API 호출 - ID: {}", companySeq);
        SearchDetailInfoCompyDTO detail = companyManagementService.getCompyDetailInfo(companySeq);
        return ResponseEntity.ok(detail);
    }


    /**
     * 
     * [API] 회사 등록 (모달에서 호출)
     * 이제 이미지는 임시 폴더에 있으므로 JSON 데이터만 받습니다.
     * @author GD
     * @since 2026. 2. 20.
     * @param requestDTO
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @PostMapping(value = "/api/register")
    @ResponseBody
    public ResponseEntity<Integer> registerCompany(
            @RequestBody CompyRegisterRequestDTO requestDTO) throws Exception {

        log.info("상품 등록 API 호출 (임시파일 이동 방식): {}", requestDTO.getCompyBase().getCompanyName());
        
        // 1. DTO에 담긴 companyLogoTempName 를 사용하여 서비스 호출
        // 서비스에서 registerInternalImgFile을 호출하여 파일을 이동시킵니다.
        Integer result = companyManagementService.registerCompy(requestDTO);
        
        return ResponseEntity.ok(result);
    }


    /**
     * 
     * [API] 회사 수정 (모달에서 호출)
     * @author GD
     * @since 2026. 2. 20.
     * @param companySeq
     * @param requestDTO
     * @param mainRemainNames
     * @param mainFiles
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @PostMapping(value = "/api/modify/{companySeq}", consumes = {"multipart/form-data"}) // PUT 대신 파일처리를 위해 POST 권장하는 경우도 있음
    @ResponseBody
    public ResponseEntity<Integer> modifyCompany(
            @PathVariable Integer companySeq,
            @RequestPart("companyData") UpdateCompyDTO requestDTO,
            @RequestParam(value = "mainRemainNames", required = false) List<String> mainRemainNames,
            @RequestPart(value = "mainFiles", required = false) List<MultipartFile> mainFiles) throws Exception {

        log.info("회사 수정 API 호출 - ID: {}", companySeq);
        requestDTO.setCompanySeq(companySeq);
        
        Integer result = companyManagementService.modifyCompy(requestDTO, mainRemainNames, mainFiles);
        return ResponseEntity.ok(result);
    }

    /**
     * 
     * [API] 회사 삭제/미사용 처리
     * @author GD
     * @since 2026. 2. 20.
     * @param requestDTO
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @PutMapping("/api/unuse")
    @ResponseBody
    public ResponseEntity<Integer> unUseCompany(@RequestBody UpdateCompyDTO requestDTO) throws Exception {
        
        log.info("회사 미사용 처리 API 호출 - ID: {}", requestDTO.getCompanySeq());
        Integer result = companyManagementService.unUseCompy(requestDTO);
        return ResponseEntity.ok(result);
    }
    
    /**
     * 
     * 회사 관리 엑셀 일괄등록 양식 다운로드
     * @author GD
     * @since 2026. 2. 20.
     * @param response
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @GetMapping("/download/template")
    public void downloadTemplate(HttpServletResponse response) {
        try {
        	companyExcelService.companyTempDownload(response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    /**
     * 
     * 회사 엑셀 일괄 업로드 실행
     * @author GD
     * @since 2026. 2. 20.
     * @param file 엑셀 파일 (MultipartFile)
     * @return 성공/실패 건수 및 내역
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
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
            ExcelUploadResultDTO<CompyUploadExcelDTO> result = companyExcelService.processUpload(file);

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
     * @since 2026. 2. 20.
     * @param response
     * @param failListJson
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
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
            headerMap.put("회사명", "companyName");
            headerMap.put("회사번호", "companyPhone");
            headerMap.put("한글주소", "addrKor");
            headerMap.put("영문주소", "addrEng");
            headerMap.put("우편번호", "zipCode");
            headerMap.put("사업자번호", "bizNumber");
            headerMap.put("통관번호", "customsNum");
            headerMap.put("대표자ID", "masterId");
            headerMap.put("등록자ID", "regId");
            headerMap.put("사용여부", "useYn");
            headerMap.put("회사로고이미지명", "companyLogoFileNm"); // 엑셀헤더 "메인이미지명" -> DTO "companyLogoFileNm"

            // 3. 수정된 서비스 호출 (headerMap 인자 추가)
            excelService.downloadFailReport(response, failList, headerMap);
            
        } catch (Exception e) {
            log.error("실패 리포트 다운로드 중 오류 발생", e);
        }
    }

    /**
     * 
     * 회사 목록 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 20.
     * @param params 검색 조건
     * @param response
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 20.  GD       최초 생성
     */
    @GetMapping("/download/excel")
    public void downloadProductExcel(@RequestParam Map<String, Object> params, HttpServletResponse response) {
        try {
        	
            // 서비스 호출 (조회부터 엑셀 생성까지 처리)
        	companyExcelService.downloadCompanyExcel(response, params);
            
        } catch (Exception e) {
        	
            log.error("회사 목록 엑셀 다운로드 중 오류 발생", e);
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
