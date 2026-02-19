package io.github.teamb.btob.service.mgmtAdm.etp;

import java.util.Map;

import jakarta.servlet.http.HttpServletResponse;

public interface EtpExcelService {

		// 견적/주문/구매/결제 이력 조회 자료 엑셀 다운로드
		void downloadProductExcel(HttpServletResponse response, Map<String, Object> params) throws Exception;
}
