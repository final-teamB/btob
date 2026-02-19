package io.github.teamb.btob.service.mgmtAdm.etp;

import java.util.List;
import java.util.Map;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.dto.mgmtAdm.etp.EtpApprovRejctRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;

public interface EtpManagementService {
	
		// 견적/주문/구매/결제 관리 조회 및 건 수
		PagingResponseDTO<SearchEtpListDTO> getSearchConditionEtpList(
											Map<String, Object> searchParams) throws Exception;
		
		// 승인/반려 버튼
		Integer handleApprovalRejctButton(EtpApprovRejctRequestDTO etpApprovRejctRequestDTO) throws Exception;
		
		// 셀렉박스 ( 필터박스 ) 주문상태, 연도별
		Map<String, List<SelectBoxVO>> getEtpFilterSelectBoxList();
}
