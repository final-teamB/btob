package io.github.teamb.btob.controller.mgmtAdm.product;

import java.util.List;
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
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.service.mgmtAdm.product.ProductUserViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/productView")
public class ProductUserViewPgController {
	
	private final ProductUserViewService productUserViewService;
	
	/**
     * 
     * [PAGE] 사용자 상품 페이지 메인
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
        model.addAttribute("pageTitle", "사용자 상품 페이지");
        
        // 추가: 셀렉박스 데이터(유류종류, 원산지, 단위, 상태) 조회 및 전달
        model.addAttribute("selectBoxes", productUserViewService.getProductUsrSideBarList());
        
        // 레이아웃의 content 영역에 삽입될 JSP 경로
        model.addAttribute("content", "mgmtAdm/product/productUserView.jsp");
        return "layout/layout2";
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
	 public ResponseEntity<Map<String, List<SelectBoxVO>>> getProductUsrSideBar() {
	 	
	     return ResponseEntity.ok(productUserViewService.getProductUsrSideBarList());
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
	 public ResponseEntity<PagingResponseDTO<SearchConditionProductDTO>> getUsrProductList(
			 @RequestParam Map<String, Object> searchParams, 
		        @RequestParam(value="countryList", required=false) List<String> countryList,
		        @RequestParam(value="fuelCatList", required=false) List<String> fuelCatList,
		        @RequestParam(value="sttsList", required=false) List<String> sttsList) throws Exception {
	     
	     log.info("상품 목록 조회 API 호출: {}", searchParams);
	     
	     // 맵에 리스트들을 다시 담아줍니다. 
	     // 이렇게 하면 MyBatis의 <foreach>가 정상적으로 List 객체를 인식합니다.
	     if (countryList != null) searchParams.put("countryList", countryList);
	     if (fuelCatList != null) searchParams.put("fuelCatList", fuelCatList);
	     if (sttsList != null) searchParams.put("sttsList", sttsList);
	     PagingResponseDTO<SearchConditionProductDTO> response = productUserViewService.getSearchConditionUsrProductList(searchParams);
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
	 public ResponseEntity<SearchDetailInfoProductDTO> getUsrProductDetail(@PathVariable Integer fuelId) throws Exception {
	     
	     log.info("상품 상세 조회 API 호출 - ID: {}", fuelId);
	     SearchDetailInfoProductDTO detail = productUserViewService.getUsrProductDetailInfo(fuelId);
	     return ResponseEntity.ok(detail);
	 }

}
