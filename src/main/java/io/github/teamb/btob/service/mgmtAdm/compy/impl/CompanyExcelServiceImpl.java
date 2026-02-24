package io.github.teamb.btob.service.mgmtAdm.compy.impl;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.CompyUploadExcelDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.InsertCompyDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.SearchConditionCompyDTO;
import io.github.teamb.btob.mapper.mgmtAdm.CompyMgmtAdmMapper;
import io.github.teamb.btob.service.attachfile.FileService;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.compy.CompanyExcelService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class CompanyExcelServiceImpl implements CompanyExcelService {

    // 엑셀 모듈
    private final ExcelService excelService;

    // 추출 데이터
    private final CompyMgmtAdmMapper compyMgmtAdmMapper;

    // 첨부파일 이미지
    private final FileService fileService;

    // 파일 이미지 미리보기 임시저장폴더
    @Value("${file.upload.path.temp}")
    private String imgTempPath;

    // 루트 경로 (공통)
    @Value("${file.upload.root}")
    private String rootPath;


    /**
     *
     * 업로드 양식 다운로드 ( 서버에 저장한 업로드 양식 파일 )
     * @author GD
     * @since 2026. 2. 17.
     * @param response
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public void companyTempDownload(HttpServletResponse response) throws Exception {

        // 1. 파일명 설정 ( 업로드 양식 파일명 )
        String fileName = "회사_관리_일괄업로드_양식.xlsx";

        // 2. 다운로드 실행
        excelService.downloadExcelTemplate(response, fileName);
    }

    /**
     *
     * 엑셀 파일 일괄 업로드
     * 사용 시 주의 사항 Transaction 걸면 안됨
     * @author GD
     * @since 2026. 2. 3.
     * @param file ( 업로드 할 엑셀 자료 파일 )
     * @return
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 3.  GD       최초 생성
     */
    @Override
    public ExcelUploadResultDTO<CompyUploadExcelDTO> processUpload(MultipartFile file) throws Exception {
        // 이 작업에서 사용할 임시 경로 설정 (예: 사용자별 혹은 세션별 폴더)
        // 이미지 일괄업로드 첨부에서만 사용합니다. 일반적인 데이터 일괄업로드시에는 해당 변수 선언 안해도 됩니다.
        //String currentTempPath = imgTempPath;

        // 1. 실제로 사용할 정확한 영문 Key 목록 (White List)
        List<String> validKeys = Arrays.asList(
                "companyCd",
        		"companyName",
                "companyPhone",
                "addrKor",
                "addrEng",
                "zipCode",
                "bizNumber",
                "customsNum",
                "masterId",
                "regId",
                "useYn",
                "companyLogoFileNm");

        // 2. 한글-영문 매핑 정보
        // 엑셀파일하고 동일하게 맞춰야함
        Map<String, String> myHeader = new HashMap<String, String>();
        myHeader.put("회사코드", "companyCd");
        myHeader.put("회사명", "companyName");
        myHeader.put("회사번호", "companyPhone");
        myHeader.put("한글주소", "addrKor");
        myHeader.put("영문주소", "addrEng");
        myHeader.put("우편번호", "zipCode");
        myHeader.put("사업자번호", "bizNumber");
        myHeader.put("통관번호", "customsNum");
        myHeader.put("대표자ID", "masterId");
        myHeader.put("등록자ID", "regId");
        myHeader.put("사용여부", "useYn");

        myHeader.put("회사로고이미지명", "companyLogoFileNm"); // 엑셀헤더 "회사로고이미지명" -> DTO "companyLogoNm"

        // 필수로 들어가야하는 값 ( 필수 항목 정의 == null 값 검증 부분임)
        List<String> requiredKeys = List.of(
                "companyCd",
        		"companyName",
                "companyPhone",
                "addrKor",
                "addrEng",
                "zipCode",
                "bizNumber",
                "customsNum",
                "masterId",
                "regId",
                "useYn");

        // 카테고리별 시퀀스를 관리할 맵 (uploadAndSave 실행 직전에 선언)
        //Map<String, Integer> sequenceMap = new HashMap<>();

        // 3. [수정 핵심] 공통 모듈의 uploadAndSave 호출
        ExcelUploadResultDTO<CompyUploadExcelDTO> result = excelService.uploadAndSave(
                file,
                myHeader,
                validKeys,
                requiredKeys,
                CompyUploadExcelDTO.class,					// 엑셀 추출할 양식의 DTO
                // dto -> atchFileMapper.insertFile(dto) 		// 각 행마다 실행될 저장 로직
                // 업데이트 테이블이 2개 이상인 경우 하단 방식으로 진행 DTO 참조요망
                dto -> {
                    try {

                        // 1. 기본 정보 저장
                        InsertCompyDTO base = dto.toBaseDTO();

                        // 회사코드 자동생성 company_cd
                        // --- [회사코드 자동생성 로직 핵심] ---
                        // 자동생성 안함
						/*
						 * String companyNm = base.getCompanyName();
						 * 
						 * Integer objId = compyMgmtAdmMapper.selectAutoObjId(); int year =
						 * LocalDate.now().getYear(); String companyCd = year + "-" + companyNm + "-" +
						 * objId; base.setCompanyCd(companyCd);
						 */

                        // --- [회사코드 자동생성 로직 종료] ---

                        compyMgmtAdmMapper.insertCompyAdm(base);
                        Integer companySeq = base.getCompanySeq();

                        System.out.println("생성된 회사 ID (companySeq): " + companySeq);

                        // 이미지 일괄업로드 시에만 사용합니다.
                        // 일반 데이터 업로드 시에는 2번사항까지만 진행
                        // 3. 회사 로고 이미지 등록
                        if (dto.getCompanyLogoFileNm() != null &&
                                !dto.getCompanyLogoFileNm().isEmpty()) {

                            AtchFileDto mainDto = dto.toAtchFileDTO(companySeq, "COMPANY", dto.getCompanyLogoFileNm());
                            fileService.registerInternalImgFile(mainDto);
                        }
                    } catch (Exception e) {

                        // 중요: 여기서 RuntimeException을 던져야 공통 모듈의 catch 블록으로 갑니다.
                        // 공통 모듈은 이 에러를 잡아서 failList에 넣고 '다음 행'으로 넘어갑니다.
                        // [핵심] 실패 원인을 콘솔에 명확히 찍어줍니다.
                        System.err.println("!!! 엑셀 행 저장 실패 원인 !!!");
                        //e.printStackTrace();
                        throw new RuntimeException(e.getMessage());
                    }
                }
        );

        // 4. 결과 반환 (컨트롤러에서 이 result를 받아 화면에 성공/실패 건수를 뿌려줍니다.)
        return result;
    }

    /**
     *
     * 회사 조회 자료 엑셀 다운로드
     * @author GD
     * @since 2026. 2. 17.
     * @param response
     * @param params ( 검색 조건식 )
     * @throws Exception
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 17.  GD       최초 생성
     */
    @Override
    public void downloadCompanyExcel(HttpServletResponse response, Map<String, Object> params) throws Exception {

        // 1. DB에서 데이터 조회
        List<SearchConditionCompyDTO> dataList = compyMgmtAdmMapper.selectCompySearchConditionListAdm(params);

        // 2. 엑셀 헤더 설정 (LinkedHashMap을 써야 넣은 순서대로 엑셀 컬럼이 생깁니다)
        Map<String, String> headerMap = new LinkedHashMap<String, String>();
        headerMap.put("rownm", "순번");
        headerMap.put("companySeq", "회사식별자");
        headerMap.put("companyCd", "회사코드");
        headerMap.put("companyName", "회사명");
        headerMap.put("companyPhone", "회사번호");
        headerMap.put("masterId", "대표자ID");
        headerMap.put("userName", "대표자명");
        headerMap.put("bizNumber", "사업자번호");
        headerMap.put("customsNum", "통관번호");
        headerMap.put("regDtime", "등록일시");
        headerMap.put("updDtime", "수정일시");
        headerMap.put("useYn", "사용여부");

        // 3. 파일명 설정
        String fileName = "회사_목록_리스트_" + System.currentTimeMillis();

        // 4. 공통 모듈 호출
        excelService.downloadExcel(response, fileName, headerMap, dataList);
    }
}
