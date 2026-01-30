package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.EstMgmtAdmDTO;


@Mapper
public interface EstMgmtAdmMapper {
	
	// 견적서 조회
	// Integer startRow, Integer limit, String searchCondition
	List<EstMgmtAdmDTO> selectEstMstListAdm(Map<String, Object> searchParams);
	
	// 견적서 조회 건수
	Integer countEstMstListCntAdm(String searchCondition);
	
	// 견적서 상세 조회 ( 견적서 출력 시에 사용 )
	EstMgmtAdmDTO selectEstMstInfoByIdAdm(Integer estId);
	void selectEstMstInfoCartList(Integer cartId);
	
	// 견적서 요청 (  )
	
	// 견적서 삭제
	int deleteEstMstListByIdAdm(Integer estId);
	int deleteEstHistAdm(Integer estId);
}
