package io.github.teamb.btob.service.mgmtAdm.compy.impl;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.dto.common.PagingResponseDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.*;
import io.github.teamb.btob.mapper.mgmtAdm.CompyMgmtAdmMapper;
import io.github.teamb.btob.service.attachfile.FileService;
import io.github.teamb.btob.service.common.CommonService;
import io.github.teamb.btob.service.mgmtAdm.compy.CompanyManagementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CompanyManagementServiceImpl implements CompanyManagementService {

    @Value("${file.upload.root}")
    private String rootPath;

    private final CommonService commonService;
    private final FileService fileService;
    private final CompyMgmtAdmMapper compyMgmtAdmMapper;

    /**
     *
     * 회사 검색 조회(관리자)
     * @author GD
     * @since 2026. 2. 2.
     * @param searchParams
     * @return PagingResponseDTO<>(companyList, totalCnt)
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public PagingResponseDTO<SearchConditionCompyDTO> getSearchConditionCompyList(Map<String, Object> searchParams) throws Exception {

        // 파라미터 검증
        /* 조회 빈값이면 오류 떠서 주석처리
         * if ( !(commonService.nullEmptyChkValidate(searchParams)) ) {
         *
         * throw new Exception("유효 하지 않은 파라미터 입니다."); }
         */

        // [중요] LIMIT 절 에러 방지를 위해 String으로 넘어온 숫자를 Integer로 명시적 형변환
        if (searchParams.get("startRow") != null) {
            int startRow = Integer.parseInt(String.valueOf(searchParams.get("startRow")));
            searchParams.put("startRow", startRow);
        }

        if (searchParams.get("limit") != null) {
            int limit = Integer.parseInt(String.valueOf(searchParams.get("limit")));
            searchParams.put("limit", limit);
        }

        // 1. 전체 건수 조회 (검색 조건 유지)
        // searchParams에서 검색 키워드만 뽑아서 전달
        //String searchCondition = (String) searchParams.get("searchCondition");
        Integer totalCnt = compyMgmtAdmMapper.selectCompySearchConditionListCntAdm(searchParams);

        // 2. 목록 조회 (Paging 처리가 포함된 Params 전달)
        List<SearchConditionCompyDTO> companyList = Collections.emptyList();

        if (totalCnt > 0) {

            companyList = compyMgmtAdmMapper.selectCompySearchConditionListAdm(searchParams);
        }

        // 3. 통합 객체로 반환
        return new PagingResponseDTO<>(companyList, totalCnt);
    }

    /**
     *
     * 상품 상세 정보 조회
     * @author GD
     * @since 2026. 2. 17.
     * @param companySeq
     * @return SearchDetailInfoCompyDTO
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public SearchDetailInfoCompyDTO getCompyDetailInfo(Integer companySeq) throws Exception {

        if ( !(commonService.nullEmptyChkValidate(companySeq)) ) {
            throw new Exception("유효 하지 않은 파라미터 입니다.");
        }

        SearchDetailInfoCompyDTO companyDetailInfo = compyMgmtAdmMapper.selectCompyDetailInfoByIdAdm(companySeq);

        if ( !(commonService.nullEmptyChkValidate(companyDetailInfo)) ) {
            throw new Exception("조회된 회사 상세 정보가 없습니다.");
        }

        if (companyDetailInfo.getStrFileNm() != null) {
            // 이미지 표출 API
            companyDetailInfo.setFileUrl("/api/file/display/" + companyDetailInfo.getSystemId() + "?fileName=" + companyDetailInfo.getStrFileNm());
        }
        return companyDetailInfo;
    }

    /**
     *
     * 회사 등록 (임시 업로드된 파일을 정식 경로로 이동 처리)
     * @author GD
     * @since 2026. 2. 17.
     * @param requestDTO 회사 정보 및 파일명
     * @return 등록 결과 (성공 시 1 이상)
     * @throws Exception
     */
    @Override
    public Integer registerCompy(CompyRegisterRequestDTO requestDTO) throws Exception {

        // 1. 회사 기본 정보 등록
        // 회사코드 자동생성
        String companyNm = requestDTO.getCompyBase().getCompanyName();

        Integer objId = compyMgmtAdmMapper.selectAutoObjId();
        int year = LocalDate.now().getYear();
        String companyCd = year + "-" + companyNm + "-" + objId;
        requestDTO.getCompyBase().setCompanyCd(companyCd);


        // Insert 후 Mybatis의 selectKey 등을 통해 requestDTO.getCompyBase().getCompanySeq에 값이 채워져야 합니다.
        Integer result = compyMgmtAdmMapper.insertCompyAdm(requestDTO.getCompyBase());

        if (result > 0) {
            Integer companySeq = requestDTO.getCompyBase().getCompanySeq();

            if (companySeq == null || companySeq == 0) {
                throw new Exception("회사 ID(companySeq) 생성에 실패하였습니다.");
            }

            // 2. 회사 로고 이미지 처리 (임시 폴더 -> 정식 폴더 이동 및 DB 등록)
            // 일단 필수로 두진 않았음.
            if (requestDTO.getCompanyLogoTempName() != null &&
                    !requestDTO.getCompanyLogoTempName().isEmpty()) {

                    String tempName = requestDTO.getCompanyLogoTempName();

                    AtchFileDto fileDto = new AtchFileDto();
                    fileDto.setOrgFileNm(tempName);       // 미리보기 시 서버에 저장된 임시 파일명
                    fileDto.setSystemId("COMPANY");       // 메인 이미지 구분값
                    fileDto.setRefId(companySeq);         // 생성된 회사 ID 연결

                    // 파일 서비스의 이동 로직 호출
                    fileService.registerInternalImgFile(fileDto);
            }

        } else {
            throw new Exception("회사 정보 등록에 실패하였습니다.");
        }

        return result;
    }

    /**
     *
     * 회사 정보 수정
     * @author GD
     * @since 2026. 2. 4.
     * @param updateCompyDTO
     * @param mainRemainNames  화면에서 안 지우고 남겨둔 이미지 파일명 리스트
     * @param mainFiles  새로 추가한 이미지 파일들
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public Integer modifyCompy(UpdateCompyDTO updateCompyDTO,
                               List<String> mainRemainNames,
                               List<MultipartFile> mainFiles) throws Exception {

        if ( !(commonService.nullEmptyChkValidate(updateCompyDTO)) ) {
            throw new Exception("유효 하지 않은 파라미터 입니다.");
        }


        Integer companySeq = updateCompyDTO.getCompanySeq();
        String useYn = updateCompyDTO.getUseYn();

        // 회사 세부 정보 수정
        Integer result = compyMgmtAdmMapper.updateCompyAdm(updateCompyDTO);

        if (result > 0) {

            // 회사 로고 이미지 처리
            // 기존 파일 정리: 남겨둔 파일 리스트(mainRemainNames)에 없는 건 다 N 처리
            fileService.updateUnusedFiles("COMPANY", companySeq, mainRemainNames);

            // 새로 추가된(또는 유지된) 파일명을 정식 등록 로직으로 처리
            if (mainRemainNames != null) {
                for (String fileName : mainRemainNames) {
                    if (fileName == null || fileName.isEmpty()) continue;

                    AtchFileDto fileDto = new AtchFileDto();
                    fileDto.setOrgFileNm(fileName); // 임시 파일명
                    fileDto.setSystemId("COMPANY");
                    fileDto.setRefId(companySeq);

                    // registerInternalImgFile 내부에서 임시폴더에 파일이 있을 경우에만 정식 이동/DB등록 수행함
                    AtchFileDto mainSaved = fileService.registerInternalImgFile(fileDto);
                    if (mainSaved != null && mainSaved.getFileId() != null) {

                        fileService.updateUseYnByDetailChg(useYn, mainSaved.getFileId(), mainSaved.getStrFileNm());
                    }
                }
            }

            // [추가] 이미지가 새로 등록되지 않았더라도 기존 이미지들의 useYn을 동기화해야 함
            syncExistingFilesStatus(companySeq, "COMPANY", useYn);

        } else {
            throw new Exception("회사 정보 수정에 실패했습니다.");
        }

        return result;

    }


    /**
     *
     * 기존에 이미 등록되어 있던 파일들의 상태(useYn)를 현재 상품 상태와 동기화
     * @param companySeq
     * @param systemId
     * @param useYn
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    private void syncExistingFilesStatus(Integer companySeq, String systemId, String useYn) throws Exception {

        // getFileIdAndStrFileNm이 리스트를 반환하거나 단일 객체를 반환하는 방식에 맞춰 처리
        // 예시: 해당 companySeq systemId로 현재 'Y'인 파일들을 가져와서 모두 업데이트
        try {
            AtchFileDto existingFile = fileService.getFileIdAndStrFileNm(companySeq, systemId);

            if (existingFile != null && existingFile.getFileId() != null) {

                fileService.updateUseYnByDetailChg(useYn, existingFile.getFileId(), existingFile.getStrFileNm());
            }
        } catch (Exception e) {
            // 파일이 없는 경우 skip
        }
    }

    /**
     *
     * 회사 정보 미사용 처리
     * @author GD
     * @since 2026. 2. 2.
     * @param requestDTO
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public Integer unUseCompy(UpdateCompyDTO requestDTO) throws Exception {

        if ( !(commonService.nullEmptyChkValidate(requestDTO)) ) {
            throw new Exception("유효 하지 않은 파라미터 입니다.");
        }

        // 상품 기본 정보 미사용
        Integer result = compyMgmtAdmMapper.deleteCompyByIdAdm(requestDTO);

        if (result > 0) {

            // 첨부파일 미사용 처리
            List<Integer> refIds = new ArrayList<>();
            refIds.add(requestDTO.getCompanySeq());

            // 로그인한 사용자가 되어야함 수정필요함 세션에서 가져오던가
            String loginUser = "admin@gmail.com";
            requestDTO.setUpdId(loginUser);

            fileService.updateUnuseAtchFile(refIds, requestDTO.getUpdId());
        } else {
            throw new Exception("상품 기본 정보 미사용 수정에 실패했습니다.");
        }

        return result;
    }
}
