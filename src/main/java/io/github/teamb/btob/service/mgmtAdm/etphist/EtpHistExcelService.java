package io.github.teamb.btob.service.mgmtAdm.etphist;

import java.util.Map;

import jakarta.servlet.http.HttpServletResponse;

public interface EtpHistExcelService {
	
	// 히스토리 이력 조회 자료 엑셀 다운로드
	void downloadEtpHistExcel(HttpServletResponse response, Map<String, Object> params) throws Exception;
}
