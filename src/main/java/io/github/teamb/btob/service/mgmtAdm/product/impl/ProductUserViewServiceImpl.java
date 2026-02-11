package io.github.teamb.btob.service.mgmtAdm.product.impl;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.mapper.mgmtAdm.ProductUserViewMapper;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductUserViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class ProductUserViewServiceImpl implements ProductUserViewService {

	private final CommonService commonService;
	private final ProductUserViewMapper productUserViewMapper;
	
	/**
	 * 
	 * 사용자 상품 페이지 상품 검색 조회
	 * @author GD
	 * @since 2026. 2. 10.
	 * @param searchParams
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 10.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchConditionProductDTO> getSearchConditionUsrProductList(Map<String, Object> searchParams)
			throws Exception {

		
				// 파라미터 검증
				/* 조회 빈값이면 오류 떠서 주석처리
				 * if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
				 * 
				 * throw new Exception("유효 하지 않은 파라미터 입니다."); }
				 */
		
				// 1. 다중 선택 가능한 필터 키 목록
			    String[] filterKeys = {"fuelCatList", "countryList", "sttsList"};
			    
			    for (String key : filterKeys) {
			        Object value = searchParams.get(key);
			        
			        if (value != null) {
			            // 값이 "LY015,QA016" 형태의 String이거나 단일 String일 경우
			            if (value instanceof String) {
			                String strValue = (String) value;
			                if (strValue.length() > 0) {
			                    // 쉼표로 분리하여 리스트로 변환
			                    List<String> list = Arrays.asList(strValue.split(","));
			                    searchParams.put(key, list);
			                }
			            } 
			            // 만약 이미 배열이나 리스트라면 그대로 둡니다.
			        }
			    }
				
				// [중요] LIMIT 절 에러 방지를 위해 String으로 넘어온 숫자를 Integer로 명시적 형변환
			    if (searchParams.get("startRow") != null) {
			        int startRow = Integer.parseInt(String.valueOf(searchParams.get("startRow")));
			        searchParams.put("startRow", startRow);
			    }
			    
			    if (searchParams.get("limit") != null) {
			        int limit = Integer.parseInt(String.valueOf(searchParams.get("limit")));
			        searchParams.put("limit", limit);
			    }
				
				// 1. 전체 건수 조회 (검색 조건 유지)
			    Integer totalCnt = productUserViewMapper.selectProductSearchConditionListCntUsr(searchParams);

			    // 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
			    List<SearchConditionProductDTO> productList = Collections.emptyList();
			    
			    if (totalCnt > 0) {
			    	
			        productList = productUserViewMapper.selectProductSearchConditionListUsr(searchParams);
			        
			        // [추가] 조회된 리스트를 돌면서 이미지 호출 풀 경로(URL)를 세팅해줌
			        for (SearchConditionProductDTO dto : productList) {
			            if (dto.getStrFileNm() != null) {
			            	
			                // 예: /api/file/display?fileName=uuid.jpg 형태
			                dto.setImgUrl("/api/file/display/PRODUCT_S?fileName=" + dto.getStrFileNm());
			            } else {
			                // 이미지가 없는 경우 기본 이미지 경로
			                dto.setImgUrl("/images/no-image.png");
			            }
			        }
			    }

			    // 3. 통합 객체로 반환
			    return new PagingResponseDTO<>(productList, totalCnt);
	}

	/**
	 * 
	 * 사용자 상품 페이지 상품 상세 정보 
	 * @author GD
	 * @since 2026. 2. 10.
	 * @param fuelId
	 * @return productDetailInfo
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 10.  GD       최초 생성
	 */
	@Override
	public SearchDetailInfoProductDTO getUsrProductDetailInfo(Integer fuelId) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(fuelId)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		SearchDetailInfoProductDTO productDetailInfo = productUserViewMapper.selectProductDetailInfoByIdUsr(fuelId);
		
		if ( !(commonService.nullEmptyChkValidate(productDetailInfo)) ) {
		    throw new Exception("조회된 상품 상세 정보가 없습니다.");
		}
		
		if (productDetailInfo.getFileList() != null) {
	        
			// 상세조회 결과 안의 파일 리스트를 돌면서 URL 세팅
	        for (AtchFileDto file : productDetailInfo.getFileList()) {
	           
	        	if (file.getStrFileNm() != null) {
	                
	            	// systemId를 동적으로 넣어서 경로를 타게 함
	                file.setFileUrl("/api/file/display/" + file.getSystemId() + "?fileName=" + file.getStrFileNm());
	            }
	        }
	    }
		
		return productDetailInfo;
	}
	
	/**
	 * 
	 * 셀렉박스 리스트 추출
	 * @author GD
	 * @since 2026. 2. 6.
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 6.  GD       최초 생성
	 */
	@Override
	public Map<String, List<SelectBoxVO>> getProductUsrSideBarList() {
	    
	    Map<String, List<SelectBoxVO>> resultMap = new HashMap<>();
	    
	    // 공통 설정 (테이블명, 컬럼명 등)
	    String table = "COMM_TBL";
	    String codeCol = "COMM_NO";
	    String nameCol = "COMM_NAME";
	    String targetCol = "PARAM_VALUE"; 

	    // 1. 유류종류 (FUEL_CAT)
	    resultMap.put("fuelCatList", getSelectBox(table, codeCol, nameCol, targetCol, "FUEL_CAT"));

	    // 2. 원산지 국가 (COUNTRY)
	    resultMap.put("countryList", getSelectBox(table, codeCol, nameCol, targetCol, "COUNTRY"));

	    // 3. 단위 (VOL_UNIT)
	    resultMap.put("volUnitList", getSelectBox(table, codeCol, nameCol, targetCol, "VOL_UNIT"));

	    // 4. 재고상태 (FUEL_ITEM_STTS)
	    resultMap.put("itemSttsList", getSelectBox(table, codeCol, nameCol, targetCol, "FUEL_ITEM_STTS"));

	    return resultMap;
	}

	/**
	 * 
	 * 셀렉박스 파라미터 세팅을 위한 내부 헬퍼 메서드 (리턴타입 VO로 수정)
	 * @author GD
	 * @since 2026. 2. 6.
	 * @param table
	 * @param cd
	 * @param nm
	 * @param target
	 * @param where
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 6.  GD       최초 생성
	 */
	private List<SelectBoxVO> getSelectBox(String table, String cd, String nm, String target, String where) {
	    
	    SelectBoxListDTO dto = new SelectBoxListDTO();
	    dto.setCommonTable(table);
	    dto.setCommNo(cd);
	    dto.setCommName(nm);
	    dto.setTargetCols(target);
	    dto.setWhereCols(where);
	    
	    // 이제 Generic 파라미터(class)를 넘길 필요 없이 깔끔하게 호출 가능합니다.
	    return commonService.getSelectBoxList(dto);
	}

}
