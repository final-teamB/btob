package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.est.EstDocDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstCartDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstCartItemDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstDocDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.InsertEstMstDTO;
import io.github.teamb.btob.dto.mgmtAdm.est.SearchConditionEstDTO;


@Mapper
public interface EstMgmtAdmMapper {
	
	// 견적서 조회
	// Integer startRow, Integer limit, String searchCondition
	List<SearchConditionEstDTO> selectEstSearchConditionListAdm(Map<String, Object> searchParams);
	
	// 견적서 조회 건수
	Integer selectEstSearchConditionListCntAdm(String searchCondition);
	
	// 견적서 상세 조회 ( 총액계산은 자바단에서 계산 )
	EstDocDTO selectEstDocByIdAdm (Integer estId);
	
	// 견적서 요청
	// 1. 견적서 메인 장바구니 생성
	Integer insertEstCartAdm(InsertEstCartDTO insertEstCartDTO);
	// 2. 견적서 장바구니 물품 등록
	Integer insertEstCartItemsAdm(InsertEstCartItemDTO insertEstCartItemDTO);
	// 3. 견적서 문서 생성
	Integer insertEstDocAdm(InsertEstDocDTO insertEstDocDTO);
	// 4. 견적서 메인 생성
	Integer insertEstMstAdm(InsertEstMstDTO insertEstMstDTO);

	// 견적서 삭제
	Integer unUseEstAdm(Integer estId);
}
