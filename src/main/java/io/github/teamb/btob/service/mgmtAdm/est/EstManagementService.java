package io.github.teamb.btob.service.mgmtAdm.est;

import java.util.Map;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.EstDocDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.EstRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.SearchConditionEstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.UnUseEstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.UpdateEstDocMstDTO;

public interface EstManagementService {	
	
	// 견적서 조회
	PagingResponseDTO<SearchConditionEstDTO> getSearchConditionEstList(
										Map<String, Object> searchParams) throws Exception;
	
	// 견적서 상세 조회
	EstDocDTO getEstDetailInfo (Integer estId) throws Exception;
	
	// 견적서 요청
	Integer registerEst(EstRequestDTO RequestDTO) throws Exception;
	
	// 견적서 문서 수정
	Integer modifyEst(UpdateEstDocMstDTO updateEstDocDTO) throws Exception;
	
	// 견적서 유효 기한 연장 ( 최대 7일 ) 관리자만 사용가능 ( 문의 전화로 왔을때 )
	Integer extenedExpireDtimeByUseAdm(Integer estDocId) throws Exception;
	
	// 견적서 삭제
	Integer unUseEst(UnUseEstDTO unUseEstDTO) throws Exception;
}
