package io.github.teamb.btob.service.mgmtAdm.compy;

import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.compy.CompyUploadExcelDTO;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public interface CompanyExcelService {

    // 상품 일괄등록 양식 다운로드
    void companyTempDownload(HttpServletResponse response) throws Exception;

    // 상품 엑셀 파일 일괄 업로드
    ExcelUploadResultDTO<CompyUploadExcelDTO> processUpload(MultipartFile file) throws Exception;

    // 상품 조회 자료 엑셀 다운로드
    void downloadCompanyExcel(HttpServletResponse response, Map<String, Object> params) throws Exception;
}
