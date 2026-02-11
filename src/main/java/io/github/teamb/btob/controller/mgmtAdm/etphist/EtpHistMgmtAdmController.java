package io.github.teamb.btob.controller.mgmtAdm.etphist;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;
import io.github.teamb.btob.service.mgmtAdm.etphist.EtpHistExcelService;
import io.github.teamb.btob.service.mgmtAdm.etphist.EtpHistManagementService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/etphist")
public class EtpHistMgmtAdmController {
	
	private final EtpHistManagementService etpHistManagementService;
    private final EtpHistExcelService etpHistExcelService;

    /**
     * 
     * 히스토리 관리 페이지 이동
     * @author GD
     * @since 2026. 2. 10.
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @GetMapping("/list")
    public String goEtpHistMain(Model model) {
    	
    	model.addAttribute("pageTitle", "히스토리 이력 관리");
        
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/hist/etpHistMgmtAdm.jsp");
        return "layout/layout";
    }

    /**
     * 
     * 히스토리 이력 목록 조회 (API)
     * @author GD
     * @since 2026. 2. 10.
     * @param params
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchEtpHistListDTO>> getEtpHistList(
            @RequestParam Map<String, Object> params) throws Exception {
        
        log.info("히스토리 목록 조회 파라미터: {}", params);
        return ResponseEntity.ok(etpHistManagementService.getSearchConditionEstHistList(params));
    }

    /**
     * 
     * 히스토리 이력 상세 조회 (API)
     * 특정 주문(etpId)에 대한 히스토리 흐름을 조회
     * @author GD
     * @since 2026. 2. 10.
     * @param etpId
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @GetMapping("/api/detail/{etpId}")
    @ResponseBody
    public ResponseEntity<PagingResponseDTO<SearchEtpHistListDTO>> getEtpHistDetail(
            @PathVariable("etpId") Integer etpId) throws Exception {
        
        log.info("히스토리 상세 조회 ID: {}", etpId);
        return ResponseEntity.ok(etpHistManagementService.getSearchConditionEstHistDetailList(etpId));
    }

    /**
     * 
     * 히스토리 이력 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 10.
     * @param response
     * @param params
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 10.  GD       최초 생성
     */
    @GetMapping("/download/excel")
    public void downloadEtpHistExcel(
            HttpServletResponse response, 
            @RequestParam Map<String, Object> params) throws Exception {
        
        log.info("히스토리 엑셀 다운로드 요청: {}", params);
        
        // 프론트에서 isExcel='Y'를 던져주겠지만, 안전하게 한 번 더 체크
        params.put("isExcel", "Y");
        
        etpHistExcelService.downloadProductExcel(response, params);
    }
}