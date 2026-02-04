package io.github.teamb.btob.service.mgmtAdm.etphist.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;
import io.github.teamb.btob.mapper.mgmtAdm.EtpHistMgmtAdmMapper;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.etphist.EtpHistManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class EtpHistManagementServiceImpl implements EtpHistManagementService{
	
	private final CommonService commonService;
	private final EtpHistMgmtAdmMapper etpHistMgmtAdmMapper;
	
	/**
	 * 
	 * 히스토리 이력 검색 조회
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
	public PagingResponseDTO<SearchEtpHistListDTO> getSearchConditionEstHistList(Map<String, Object> searchParams)
			throws Exception {
			
			// 파라미터 검증
			if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
				
				throw new Exception("유효 하지 않은 파라미터 입니다.");
			}
			
			// 1. 전체 건수 조회 (검색 조건 유지)
			// searchParams에서 검색 키워드만 뽑아서 전달
			String searchCondition = (String) searchParams.get("searchCondition");
			Integer totalCnt = etpHistMgmtAdmMapper.selectEtpHistSearchConditioinListCntAdm(searchCondition);
	
			// 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
			List<SearchEtpHistListDTO> histList = Collections.emptyList();
			
			if (totalCnt > 0) {
				
				histList = etpHistMgmtAdmMapper.selectEtpHistSearchConditioinListAdm(searchParams);
			}
	
			// 3. 통합 객체로 반환
			return new PagingResponseDTO<>(histList, totalCnt);
	}
	
	/**
	 * 
	 * 히스토리 이력 상세 조회
	 * @author GD
	 * @since 2026. 2. 2.
	 * @param etpId
	 * @return
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 2.  GD       최초 생성
	 */
	@Override
	public PagingResponseDTO<SearchEtpHistListDTO> getSearchConditionEstHistDetailList(Integer etpId)
			throws Exception {
		
		// 파라미터 검증
		if ( !(commonService.nullEmptyChkValidate(etpId)) ) {
			
			throw new Exception("유효 하지 않은 파라미터 입니다.");
		}
		
		// 1. 전체 건수 조회
		Integer totalCnt = etpHistMgmtAdmMapper.selectEtpHistListCntById(etpId);

		// 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
		List<SearchEtpHistListDTO> histList = Collections.emptyList();
		
		if (totalCnt > 0) {
			
			histList = etpHistMgmtAdmMapper.selectEtpHistListById(etpId);
		}

		// 3. 통합 객체로 반환
		return new PagingResponseDTO<>(histList, totalCnt);
	}
}
