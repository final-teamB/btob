package io.github.teamb.btob.mapper.mgmtAdm;

import io.github.teamb.btob.dto.mgmtAdm.compy.InsertCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchConditionCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchDetailInfoCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.UpdateCompyDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CompyMgmtAdmMapper {

    // 회사 검색 조회
    List<SearchConditionCompyDTO> selectCompySearchConditionListAdm(Map<String, Object> searchParams);

    // 회사 검색 조회 건수
    Integer selectCompySearchConditionListCntAdm(Map<String, Object> searchParams);

    // 회사 상세 조회
    SearchDetailInfoCompyDTO selectCompyDetailInfoByIdAdm(Integer companySeq);

    // 회사 등록
    Integer insertCompyAdm(InsertCompyDTO insertCompyDTO);

    // 회사 정보 수정
    Integer updateCompyAdm(UpdateCompyDTO updateCompyDTO);

    // 회사 삭제 ( 비활성화 )
    Integer deleteCompyByIdAdm(UpdateCompyDTO updateCompyDTO);

    // 회사코드 자동생성 식별번호 확인
    Integer selectAutoObjId();
}
