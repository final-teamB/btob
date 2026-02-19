package io.github.teamb.btob.service.mgmtAdm.compy;

import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.CompyRegisterRequestDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchConditionCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchDetailInfoCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.UpdateCompyDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface CompanyManagementService {

    // 회사 검색 조회 목록
    PagingResponseDTO<SearchConditionCompyDTO> getSearchConditionCompyList(
            Map<String, Object> searchParams) throws Exception;

    // 회사 상세 정보
    SearchDetailInfoCompyDTO getCompyDetailInfo (Integer companySeq) throws Exception;

    // 회사 등록
    Integer registerCompy(CompyRegisterRequestDTO requestDTO) throws Exception;

    // 회사 수정
    Integer modifyCompy(UpdateCompyDTO updateCompyDTO
            , List<String> mainRemainNames
            , List<MultipartFile> mainFiles) throws Exception;

    // 회사 삭제
    Integer unUseCompy(UpdateCompyDTO requestDTO) throws Exception;
}
