package io.github.teamb.btob.service.mgmtAdm.product.impl;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxListDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.product.InsertProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductModifyRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUnUseRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchConditionProductDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.SearchDetailInfoProductDTO;
import io.github.teamb.btob.mapper.mgmtAdm.ProductMgmtAdmMapper;
import io.github.teamb.btob.service.attachfile.FileService;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.product.ProductManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class ProductManagementServiceImpl implements ProductManagementService{
	
	@Value("${file.upload.root}")
    private String rootPath;
	
	private final CommonService commonService;
	private final FileService fileService;
	private final ProductMgmtAdmMapper productMgmtAdmMapper;

	/**
	 * 
	 * 상품 검색 조회(관리자)
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param searchParams
	 * @return PagingResponseDTO<>(productList, totalCnt)
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchConditionProductDTO> getSearchConditionProductList(
									Map<String, Object> searchParams) throws Exception {

		// 파라미터 검증
		/* 조회 빈값이면 오류 떠서 주석처리
		 * if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
		 * 
		 * throw new Exception("유효 하지 않은 파라미터 입니다."); }
		 */
		
		// 1. 전체 건수 조회 (검색 조건 유지)
	    // searchParams에서 검색 키워드만 뽑아서 전달
	    String searchCondition = (String) searchParams.get("searchCondition");
	    Integer totalCnt = productMgmtAdmMapper.selectProductSearchConditionListCntAdm(searchCondition);

	    // 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
	    List<SearchConditionProductDTO> productList = Collections.emptyList();
	    
	    if (totalCnt > 0) {
	    	
	        productList = productMgmtAdmMapper.selectProductSearchConditionListAdm(searchParams);
	        
	        // [추가] 조회된 리스트를 돌면서 이미지 호출 풀 경로(URL)를 세팅해줌
	        for (SearchConditionProductDTO dto : productList) {
	            if (dto.getStrFileNm() != null) {
	            	
	                // 예: /api/file/display?fileName=uuid.jpg 형태
	                dto.setImgUrl("/api/file/display/PRODUCT?fileName=" + dto.getStrFileNm());
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
	 * 상품 상세 정보 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param fuelId
	 * @return productDetailInfo
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public SearchDetailInfoProductDTO getProductDetailInfo(Integer fuelId) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(fuelId)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		SearchDetailInfoProductDTO productDetailInfo = productMgmtAdmMapper.selectProductDetailInfoByIdAdm(fuelId);
		
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
	 * 상품 등록 (임시 업로드된 파일을 정식 경로로 이동 처리)
	 * @author GD
	 * @since 2026. 2. 6. (수정)
	 * @param requestDTO 상품 정보 및 임시 파일명 리스트
	 * @return 등록 결과 (성공 시 1 이상)
	 * @throws Exception
	 */
	@Transactional(rollbackFor = Exception.class)
	@Override
	public Integer registerProduct(ProductRegisterRequestDTO requestDTO) throws Exception {
	    
	    // 1. 상품 기본 정보 등록
		// 유류코드 자동생성 fuel_cd
		String fuelCatCd = requestDTO.getProductBase().getFuelCatCd();
		String fuelCntryCd = requestDTO.getProductBase().getOriginCntryCd();
		InsertProductDTO getObjId = InsertProductDTO.builder()
									.fuelCatCd(fuelCatCd)
									.originCntryCd(fuelCntryCd)
									.build();
		
		Integer objId = productMgmtAdmMapper.selectAutoObjId(getObjId);
		int year = LocalDate.now().getYear(); 
		String fuelCd = year + "-" + fuelCatCd + "-" + fuelCntryCd + "-" + objId;
		requestDTO.getProductBase().setFuelCd(fuelCd);

	    // Insert 후 Mybatis의 selectKey 등을 통해 requestDTO.getProductBase().getFuelId()에 값이 채워져야 합니다.
	    Integer result = productMgmtAdmMapper.insertProductAdm(requestDTO.getProductBase());
	    
	    if (result > 0) {
	        Integer fuelId = requestDTO.getProductBase().getFuelId();
	        
	        if (fuelId == null || fuelId == 0) {
	            throw new Exception("상품 ID(fuelId) 생성에 실패하였습니다.");
	        }

	        // 2. 메인 이미지 처리 (임시 폴더 -> 정식 폴더 이동 및 DB 등록)
	        if (requestDTO.getMainTempNames() != null && !requestDTO.getMainTempNames().isEmpty()) {
	            for (String tempName : requestDTO.getMainTempNames()) {
	                if (tempName == null || tempName.isEmpty()) continue;
	                
	                AtchFileDto fileDto = new AtchFileDto();
	                fileDto.setOrgFileNm(tempName);   // 미리보기 시 서버에 저장된 임시 파일명
	                fileDto.setSystemId("PRODUCT_M"); // 메인 이미지 구분값
	                fileDto.setRefId(fuelId);         // 생성된 상품 fuelId 연결
	                
	                // 파일 서비스의 이동 로직 호출
	                fileService.registerInternalImgFile(fileDto);
	            }
	        }

	        // 3. 서브 이미지 처리 (임시 폴더 -> 정식 폴더 이동 및 DB 등록)
	        if (requestDTO.getSubTempNames() != null && !requestDTO.getSubTempNames().isEmpty()) {
	            for (String tempName : requestDTO.getSubTempNames()) {
	                if (tempName == null || tempName.isEmpty()) continue;

	                AtchFileDto fileDto = new AtchFileDto();
	                fileDto.setOrgFileNm(tempName);   // 임시 파일명
	                fileDto.setSystemId("PRODUCT_S"); // 서브 이미지 구분값
	                fileDto.setRefId(fuelId);         // 생성된 상품 fuelId 연결
	                
	                fileService.registerInternalImgFile(fileDto);
	            }
	        }
	        
	        // 4. 상품 상세 정보 등록
	        // 에디터 본문 내용(fuelMemo) 등이 포함된 상세 정보 테이블 저장
	        requestDTO.getProductDetail().setFuelId(fuelId);
	        Integer detailResult = productMgmtAdmMapper.insertProductDetailInfoAdm(requestDTO.getProductDetail());
	        
	        if (detailResult <= 0) {
	            throw new Exception("상품 상세 정보 등록에 실패하였습니다.");
	        }
	    } else {
	        throw new Exception("상품 기본 정보 등록에 실패하였습니다.");
	    }
	    
	    return result; 
	}

	/**
	 * 
	 * 상품 정보 수정
	 * @author GD
	 * @since 2026. 2. 4.
	 * @param RequestDTO
	 * @param mainRemainNames  화면에서 안 지우고 남겨둔 메인파일명 리스트
	 * @param mainFiles  새로 추가한 메인 이미지 파일들
	 * @param subRemainNames
	 * @param subFiles
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 4.  GD       최초 생성
	 */
	@Override
	public Integer modifyProduct(ProductModifyRequestDTO requestDTO
									,List<String> mainRemainNames  
						            ,List<MultipartFile> mainFiles 
						            ,List<String> subRemainNames
						            ,List<MultipartFile> subFiles
						            ,List<String> DetailRemainNames
						            ,List<MultipartFile> detailFiles) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(requestDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		Integer fuelId = requestDTO.getProductBase().getFuelId();

		// 상품 기본 정보 수정
		Integer result = productMgmtAdmMapper.updateProductAdm(requestDTO.getProductBase());
		
		if (result > 0) {
			
				// 메인 이미지 처리 (PRODUCT_M)
			    // 기존 파일 정리: 남겨둔 파일 리스트(mainRemainNames)에 없는 건 다 N 처리
			    fileService.updateUnusedFiles("PRODUCT_M", fuelId, mainRemainNames);
			    // 신규 파일 저장
			    if (mainFiles != null && !mainFiles.isEmpty()) {
			        fileService.uploadFiles(mainFiles, "PRODUCT_M", fuelId);
			    }
	
			    // 서브 이미지 처리 (PRODUCT_S)
			    fileService.updateUnusedFiles("PRODUCT_S", fuelId, subRemainNames);
			    // 신규 파일 저장
			    if (subFiles != null && !subFiles.isEmpty()) {
			        fileService.uploadFiles(subFiles, "PRODUCT_S", fuelId);
			    }
			    
			    // 상세 이미지 처리 (PRODUCT_D)
			    fileService.updateUnusedFiles("PRODUCT_D", fuelId, DetailRemainNames);
			    // 신규 파일 저장
			    if (detailFiles != null && !detailFiles.isEmpty()) {
			        fileService.uploadFiles(detailFiles, "PRODUCT_D", fuelId);
			    }
		       
		       // 상품 상세 정보 수정
		       Integer detailResult = productMgmtAdmMapper.updateProductDetailInfoAdm(requestDTO.getProductDetail());
		       
		       if (detailResult <= 0) {
		           throw new Exception("상품 상세 정보 수정에 실패했습니다.");
		       }
		   } else {
		       throw new Exception("상품 기본 정보 수정에 실패했습니다.");
		   }
		   
		return result; 
	}

	/**
	 * 
	 * 상품 미사용 처리
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param RequestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer unUseProduct(ProductUnUseRequestDTO requestDTO) throws Exception {

		if ( !(commonService.nullEmptyChkValidate(requestDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 상품 기본 정보 미사용
		Integer result = productMgmtAdmMapper.deleteProductByIdAdm(requestDTO);
		
		if (result > 0) {
		       
		       // 상품 세부 정보 미사용
		       Integer detailResult = productMgmtAdmMapper.deleteProductDetailInfoByIdAdm(requestDTO);
		       
		       if (detailResult <= 0) {
		           throw new Exception("상품 상세 정보 미사용 수정에 실패했습니다.");
		       }
		       
		       // 첨부파일 미사용 처리
		       List<Integer> refIds = new ArrayList<>();
		       refIds.add(requestDTO.getFuelId());
		       
		       fileService.updateUnuseAtchFile(refIds, requestDTO.getUserNo());
		   } else {
		       throw new Exception("상품 기본 정보 미사용 수정에 실패했습니다.");
		   }
		   
		return result;
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
	public Map<String, List<SelectBoxVO>> registerProductSelectBoxList() {
	    
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
