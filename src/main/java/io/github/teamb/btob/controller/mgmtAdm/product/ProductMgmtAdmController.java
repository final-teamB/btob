package io.github.teamb.btob.controller.mgmtAdm.product;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/products")
public class ProductMgmtAdmController {

    private final ProductManagementService productManagementService;

    /**
     * [PAGE] 상품 관리 메인 (목록 + 등록/수정 모달 통합 페이지)
     */
    @GetMapping("/list")
    public String productListPage(Model model) {
        model.addAttribute("pageTitle", "상품 관리");
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/product/productMgmtAdm.jsp");
        return "layout/layout";
    }

    /* =========================================================
       API 영역 (모달 및 리스트 비동기 통신용)
       ========================================================= */

    /**
     * [API] 상품 목록 조회 (페이징 및 검색)
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
     * [API] 상품 상세 정보 조회 (수정 모달 데이터 바인딩용)
     */
    @GetMapping("/api/{fuelId}")
    @ResponseBody
    public ResponseEntity<SearchDetailInfoProductDTO> getProductDetail(@PathVariable Integer fuelId) throws Exception {
        
        log.info("상품 상세 조회 API 호출 - ID: {}", fuelId);
        SearchDetailInfoProductDTO detail = productManagementService.getProductDetailInfo(fuelId);
        return ResponseEntity.ok(detail);
    }

    /**
     * [API] 상품 등록 (모달에서 호출)
     */
    @PostMapping(value = "/api/register", consumes = {"multipart/form-data"})
    @ResponseBody
    public ResponseEntity<Integer> registerProduct(
            @RequestPart("productData") ProductRegisterRequestDTO requestDTO,
            @RequestPart(value = "mainFiles", required = false) List<MultipartFile> mainFiles,
            @RequestPart(value = "subFiles", required = false) List<MultipartFile> subFiles,
            @RequestPart(value = "detailFiles", required = false) List<MultipartFile> detailFiles) throws Exception {

        log.info("상품 등록 API 호출: {}", requestDTO.getProductBase().getFuelNm());
        Integer result = productManagementService.registerProduct(requestDTO, mainFiles, subFiles, detailFiles);
        return ResponseEntity.ok(result);
    }

    /**
     * [API] 상품 수정 (모달에서 호출)
     */
    @PostMapping(value = "/api/modify/{fuelId}", consumes = {"multipart/form-data"}) // PUT 대신 파일처리를 위해 POST 권장하는 경우도 있음
    @ResponseBody
    public ResponseEntity<Integer> modifyProduct(
            @PathVariable Integer fuelId,
            @RequestPart("productData") ProductModifyRequestDTO requestDTO,
            @RequestParam(value = "mainRemainNames", required = false) List<String> mainRemainNames,
            @RequestPart(value = "mainFiles", required = false) List<MultipartFile> mainFiles,
            @RequestParam(value = "subRemainNames", required = false) List<String> subRemainNames,
            @RequestPart(value = "subFiles", required = false) List<MultipartFile> subFiles,
            @RequestParam(value = "detailRemainNames", required = false) List<String> detailRemainNames,
            @RequestPart(value = "detailFiles", required = false) List<MultipartFile> detailFiles) throws Exception {

        log.info("상품 수정 API 호출 - ID: {}", fuelId);
        requestDTO.getProductBase().setFuelId(fuelId);
        
        Integer result = productManagementService.modifyProduct(
                requestDTO, mainRemainNames, mainFiles, 
                subRemainNames, subFiles, 
                detailRemainNames, detailFiles);
        return ResponseEntity.ok(result);
    }

    /**
     * [API] 상품 삭제/미사용 처리
     */
    @PutMapping("/api/unuse")
    @ResponseBody
    public ResponseEntity<Integer> unUseProduct(@RequestBody ProductUnUseRequestDTO requestDTO) throws Exception {
        
        log.info("상품 미사용 처리 API 호출 - ID: {}", requestDTO.getFuelId());
        Integer result = productManagementService.unUseProduct(requestDTO);
        return ResponseEntity.ok(result);
    }
}