package io.github.teamb.btob.service.mgmtAdm.etphist;

import java.util.Map;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;

public interface EtpHistManagementService {
	
		// 히스토리 이력 검색 조회
		PagingResponseDTO<SearchEtpHistListDTO> getSearchConditionEstHistList(
											Map<String, Object> searchParams) throws Exception;
		
		// 히스토리 이력 상세 조회
		PagingResponseDTO<SearchEtpHistListDTO> getSearchConditionEstHistDetailList(
				Integer etpId) throws Exception;
}
