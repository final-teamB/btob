package io.github.teamb.btob.mapper.mgmtAdm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;


@Mapper
public interface EtpHistMgmtAdmMapper {

	// 히스토리 검색 조회
	List<SearchEtpHistListDTO> selectEtpHistSearchConditioinListAdm(Map<String, Object> searchParams);
	
	// 히스토리 검색 조회 건수
	Integer selectEtpHistSearchConditioinListCntAdm(String searchCondition);
	
	// 히스토리 개별 조회 
	List<SearchEtpHistListDTO> selectEtpHistListById(Integer etpId);
	
	// 히스토리 개별 조회 건수
	Integer selectEtpHistListCntById(Integer etpId);
}
