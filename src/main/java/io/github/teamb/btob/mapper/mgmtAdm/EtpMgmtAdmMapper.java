package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;

@Mapper
public interface EtpMgmtAdmMapper {
	
	// 견적/주문/구매/결제 검색 조회
	List<SearchEtpListDTO> selectEtpSearchConditioinListAdm(Map<String, Object> searchParams);
	
	// 견적/주문/구매/결제 검색 조회 건수
	Integer selectEtpSearchConditioinListCntAdm(Map<String, Object> searchParams);
	
	// 관리자가 처리 할 수 있는 상태변경 권한 (승인,반려)
	List<SearchEtpListDTO> approvRejctChgAuthByAdm();
}
