package io.github.teamb.btob.controller.mgmtAdm.etp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.etp.EtpApprovRejctRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;
import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;
import io.github.teamb.btob.service.mgmtAdm.etp.EtpManagementService;
import io.github.teamb.btob.service.mgmtAdm.etphist.EtpHistManagementService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/etp")
public class EtpMgmtAdmController {
	
	private final EtpManagementService etpManagementService;
	private final EtpHistManagementService etpHistManagementService;
	
	/**
     * 
     * [PAGE] 견적/주문/구매/결제 관리 메인 (목록)
     * @author GD
     * @since 2026. 2. 12.
     * @param model
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @GetMapping("/list")
    public String etpListPage(Model model) {
        model.addAttribute("pageTitle", "상품 관리");
        
        // 추가: 셀렉박스 데이터(연도별, 진행상태코드별) 조회 및 전달
        model.addAttribute("selectBoxes", etpManagementService.getEtpFilterSelectBoxList());
        
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/etp/etpMgmtAdm.jsp");
        return "layout/layout";
    }
    /* =========================================================
       API 영역 (모달 및 리스트 비동기 통신용)
       ========================================================= */

    /**
     * 
     * [API] 셀렉박스 리스트만 별도로 필요할 경우 (비동기 호출용)
     * @author GD
     * @since 2026. 2. 12.
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @GetMapping("/api/select-boxes")
    @ResponseBody
    public ResponseEntity<Map<String, List<SelectBoxVO>>> getSelectBoxes() {
    	
        return ResponseEntity.ok(etpManagementService.getEtpFilterSelectBoxList());
    }
    
    

    /**
     * 
     * [API] 견적/주문/구매/결제 관리 메인 (페이징 및 검색)
     * @author GD
     * @since 2026. 2. 12.
     * @param searchParams
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchEtpListDTO>> getEtpList(
            @RequestParam Map<String, Object> searchParams) throws Exception {
        
        log.info("견적/주문/구매/결제 목록 조회 API 호출: {}", searchParams);
        PagingResponseDTO<SearchEtpListDTO> response = etpManagementService.getSearchConditionEtpList(searchParams);
        return ResponseEntity.ok(response);
    }
    
    /**
     * 
     * [API] 견적/주문/구매/결제 히스토리 (상세조회)
     * @author GD
     * @since 2026. 2. 12.
     * @param searchParams
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @GetMapping("/api/{etpId}")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchEtpHistListDTO>> getProductList(
    		@PathVariable Integer etpId) throws Exception {
        
        log.info("상품 목록 조회 API 호출: {}", etpId);
        PagingResponseDTO<SearchEtpHistListDTO> response = etpHistManagementService.getSearchConditionEstHistDetailList(etpId);
        return ResponseEntity.ok(response);
    }
    
    /**
     * * [API] 견적 승인/반려 및 구매 승인/반려 처리
     * @author GD
     * @since 2026. 2. 12.
     * @param etpApprovRejctRequestDTO (systemId, approvalStatus, rejtRsn, orderId 포함)
     * @return 처리 성공 여부 및 결과 코드
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @PostMapping("/api/approve-reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleApproveReject(
            @RequestBody EtpApprovRejctRequestDTO etpApprovRejctRequestDTO) {
        
        log.info("관리자 승인/반려 처리 API 호출: {}", etpApprovRejctRequestDTO);
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 현재 로그인한 관리자의 정보를 세팅 (세션이나 스프링 시큐리티에서 가져와야 함)
            // 서비스 로직에서 admin@gmail.com을 하드코딩하고 계시므로, DTO에도 일단 세팅해줍니다.
            etpApprovRejctRequestDTO.setUserId("admin@gmail.com"); 

            // 서비스 호출 (상태 변경 + 히스토리 등록 + 필요시 더블스탭)
            Integer finalResult = etpManagementService.handleApprovalRejctButton(etpApprovRejctRequestDTO);
            
            if (finalResult > 0) {
                result.put("success", true);
                result.put("message", "처리가 완료되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "처리 대상 데이터가 없거나 이미 처리된 상태입니다.");
            }
            
            return ResponseEntity.ok(result);
            
        } catch (IllegalArgumentException e) {
            log.error("잘못된 요청 파라미터: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
            
        } catch (Exception e) {
            log.error("승인/반려 처리 중 서버 오류 발생", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }
    
    
    /**
     * 
     * 견적/주문/구매/결제 이력 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 12.
     * @param response
     * @param params
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 12.  GD       최초 생성
     */
    @GetMapping("/download/excel")
    public void downloadEtpHistExcel(
            HttpServletResponse response, 
            @RequestParam Map<String, Object> params) throws Exception {
        
        log.info("견적/주문/구매/결제 엑셀 다운로드 요청: {}", params);
        
        // 프론트에서 isExcel='Y'를 던져주겠지만, 안전하게 한 번 더 체크
        params.put("isExcel", "Y");
        
        //etpHistExcelService.downloadProductExcel(response, params);
    }

}
