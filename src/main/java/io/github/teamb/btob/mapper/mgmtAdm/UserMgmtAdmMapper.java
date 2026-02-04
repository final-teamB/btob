package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.user.SearchConditionUserDTO;
import io.github.teamb.btob.dto.mgmtAdm.user.SearchDetailInfoUserDTO;
import io.github.teamb.btob.dto.mgmtAdm.user.UnUserAdmDTO;
import io.github.teamb.btob.dto.mgmtAdm.user.UpdateUserAdmDTO;

@Mapper
public interface UserMgmtAdmMapper {
	
		// 사용자 검색 조회
		List<SearchConditionUserDTO> selectUserSearchConditionListAdm(Map<String, Object> searchParams);
		
		// 사용자 검색 조회 건수
		Integer selectUserSearchConditionListCntAdm(String searchCondition);
		
		// 사용자 상세조회
		SearchDetailInfoUserDTO selectUserDetailInfoByIdAdm(Integer userNo);
		
		// 사용자 등록?
		//Integer insertProductAdm(InsertProductDTO insertProductDTO);
		
		// 사용자 상세정보 등록? 이건 회원가입에서 따오기
		//Integer insertProductDetailInfoAdm(InsertDetailInfoProductDTO insertDetailInfoProductDTO);
		
		// 사용자 정보 수정
		Integer updateUserAdm(UpdateUserAdmDTO updateUserDTO);
		
		// 사용자 미사용 처리 ( 비활성화 )
		Integer UnUserByIdAdm(UnUserAdmDTO unUserAdmDTO);
}
