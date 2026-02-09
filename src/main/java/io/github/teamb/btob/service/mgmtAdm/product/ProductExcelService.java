package io.github.teamb.btob.service.mgmtAdm.product;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.excel.ExcelUploadResultDTO;
import io.github.teamb.btob.dto.mgmtAdm.product.ProductUploadExcelDTO;
import jakarta.servlet.http.HttpServletResponse;

public interface ProductExcelService {
	
	// 상품 일괄등록 양식 다운로드
	void productTempDownload(HttpServletResponse response) throws Exception;
	
	// 상품 엑셀 파일 일괄 업로드
	ExcelUploadResultDTO<ProductUploadExcelDTO> processUpload(MultipartFile file) throws Exception;
	
	// 상품 조회 자료 엑셀 다운로드
	void downloadProductExcel(HttpServletResponse response, Map<String, Object> params) throws Exception;
}
