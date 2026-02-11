package io.github.teamb.btob.service.mgmtAdm.est.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.EstDocDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.EstRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstCartItemDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstDocDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstMstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.SearchConditionEstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.UnUseEstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.UpdateEstDocMstDTO;
import io.github.teamb.btob.mapper.mgmtAdm.EstMgmtAdmMapper;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.est.EstManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class EstManagementServiceImpl implements EstManagementService{
	
	private final CommonService commonService;
	private final EstMgmtAdmMapper estMgmtAdmMapper;
	
	/**
	 * 
	 * 견적서 메인 관리 검색 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param searchParams
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchConditionEstDTO> getSearchConditionEstList(Map<String, Object> searchParams)
			throws Exception {
		
			// 파라미터 검증
			if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
				
				throw new Exception("유효 하지 않은 파라미터 입니다.");
			}
			
			// 1. 전체 건수 조회 (검색 조건 유지)
			// searchParams에서 검색 키워드만 뽑아서 전달
			String searchCondition = (String) searchParams.get("searchCondition");
			Integer totalCnt = estMgmtAdmMapper.selectEstSearchConditionListCntAdm(searchCondition);

			// 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
			List<SearchConditionEstDTO> estList = Collections.emptyList();
			
			if (totalCnt > 0) {
				
				estList = estMgmtAdmMapper.selectEstSearchConditionListAdm(searchParams);
			}

			// 3. 통합 객체로 반환
			return new PagingResponseDTO<>(estList, totalCnt);
	}
	
	/**
	 * 
	 * 견적서 상세 정보 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param estId
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public EstDocDTO getEstDetailInfo(Integer estId) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(estId)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		EstDocDTO EstDocDetailInfo = estMgmtAdmMapper.selectEstDocByIdAdm(estId);
		
		if ( !(commonService.nullEmptyChkValidate(EstDocDetailInfo)) ) {
		    throw new Exception("조회된 상품 상세 정보가 없습니다.");
		}
		
		return EstDocDetailInfo;
	}
	
	/**
	 * 
	 * 견적서 등록 ( 임시저장 )
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param requestDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer registerEst(EstRequestDTO requestDTO) throws Exception {
		
		// 1. 파라미터 전수 검사 (작성하신 통합 유틸리티 활용)
	    if (!commonService.nullEmptyChkValidate(requestDTO)) {
	        throw new Exception("유효하지 않은 파라미터입니다.");
	    }

	    // 1. 견적서 메인 장바구니 생성
	    estMgmtAdmMapper.insertEstCartAdm(requestDTO.getCart());
	    Integer estCartId = requestDTO.getCart().getEstCartId();

	    if (estCartId == null) {
	        throw new Exception("장바구니 생성에 실패했습니다.");
	    }

	    /**
	     * 이전 order 쪽 cartID에서
	     *  product_id == 상품 아이디
		 *	product_qty == 상품 가격
		 *	base_product_prc == 기본단가
         *	base_product_amt == 요청수량
         * 가져옴
         *  // 희망단가
         *  
         * 
	     */
	    
	    
	    // 2. 견적서 장바구니 물품 등록
	    List<InsertEstCartItemDTO> items = requestDTO.getItems();
	    
	    // 리스트의 각 아이템에 방금 생성된 estCartId와 등록자 ID를 세팅
	    for (InsertEstCartItemDTO item : items) {
	    	
	        item.setEstCartId(estCartId);
	        item.setRegId(requestDTO.getCart().getRequestUserId()); // 등록자 정보 세팅
	    }

	    Integer cartItemResult = estMgmtAdmMapper.insertEstCartItemsAdm(items);

	    if (cartItemResult <= 0) {
	        throw new Exception("장바구니 물품 등록에 실패했습니다.");
	    }

	    // 3. 견적서 문서 생성
	    InsertEstDocDTO docDto = requestDTO.getDoc();
	    docDto.setEstCartId(estCartId); 
	    
	    // 문서 번호(estNo) 생성 로직 (예: UUID나 날짜조합)
	    docDto.setEstNo("EST-" + System.currentTimeMillis());
	    estMgmtAdmMapper.insertEstDocAdm(docDto);

	    Integer estDocId = docDto.getEstDocId(); // 자동 생성된 문서 ID 획득

	    if (estDocId == null) {
	        throw new Exception("견적 문서 생성에 실패했습니다.");
	    }
	    
	    // 4. 견적서 메인 생성
	    InsertEstMstDTO mstDto = requestDTO.getEstMst();
	    mstDto.setEstDocId(estDocId);
	    mstDto.setEtpSttsCd("et001");

	    Integer mstResult = estMgmtAdmMapper.insertEstMstAdm(mstDto);

	    return mstResult;
	}
	
	/**
	 * 
	 * 견적서 문서 수정
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param updateEstDocDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer modifyEst(UpdateEstDocMstDTO updateEstDocDTO) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(updateEstDocDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 견적서 수정 가능 검증
		if ( estMgmtAdmMapper.updateEstValidate(updateEstDocDTO.getEstDocId()) == 0 ) {
			throw new Exception("수정 불가 단계 입니다.");
		}
		
		// 견적서 문서 수정
		Integer result = estMgmtAdmMapper.updateEstDocByIdAdm(updateEstDocDTO);
		
		if (result > 0) {
				log.info("견적서 문서 수정에 성공하였습니다.");
		   } else {
		       throw new Exception("견적서 문서 수정에 실패했습니다.");
		   }
		   
		return result; 
	}
	
	/**
	 * 
	 * 견적서 기간 연장 처리
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param estDocId
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer extenedExpireDtimeByUseAdm(Integer estDocId) throws Exception {

		if ( !(commonService.nullEmptyChkValidate(estDocId)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 견적서 수정 가능 검증
		if ( estMgmtAdmMapper.updateEstValidate(estDocId) == 0 ) {
			throw new Exception("수정 불가 단계 입니다.");
		}
		
		// 견적서 기간 연장 처리
		Integer result = estMgmtAdmMapper.updateEstDocExpireDtimeExten();
		
		if (result > 0) {
				log.info("견적서 기간 연장에 성공하였습니다.");
		   } else {
		       throw new Exception("견적서 기간 연장에 실패했습니다.");
		   }
		   
		return result; 
	}
	
	/**
	 * 
	 * 견적서 미사용 처리
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param unUseEstDTO
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public Integer unUseEst(UnUseEstDTO unUseEstDTO) throws Exception {
		
		if ( !(commonService.nullEmptyChkValidate(unUseEstDTO)) ) {
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 견적서 세부 미사용 처리
		Integer result = estMgmtAdmMapper.unUseEstDoc(unUseEstDTO.getEstDocID());
		
		if ( result > 0) {

			// 견적서 메인 미사용 처리
			if ( estMgmtAdmMapper.unUseEstAdm(unUseEstDTO) > 0) {
				log.info("견적서 메인, 세부 미사용처리 성공");
			} else {
				throw new Exception("견적서 메인 미사용 처리에 실패했습니다.");
			}
		} else {
			throw new Exception("견적서 세부 미사용 처리에 실패했습니다.");
		}
		   
		return result; 
	}
}
