package io.github.teamb.btob.service.mgmtAdm.etp.iml;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.mgmtAdm.etp.SearchEtpListDTO;
import io.github.teamb.btob.mapper.mgmtAdm.EtpMgmtAdmMapper;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.etp.EtpExcelService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EtpExcelServiceImpl implements EtpExcelService{

	private final EtpMgmtAdmMapper etpMgmtAdmMapper;
	private final ExcelService excelService;
	
	@Override
	public void downloadProductExcel(HttpServletResponse response, Map<String, Object> params) throws Exception {
		
		// 1. DB에서 데이터 조회
		List<SearchEtpListDTO> dataList = etpMgmtAdmMapper.selectEtpSearchConditioinListAdm(params);
		
		// 2. 엑셀 헤더 설정 (LinkedHashMap을 써야 넣은 순서대로 엑셀 컬럼이 생깁니다)
		Map<String, String> headerMap = new LinkedHashMap<String, String>();
		headerMap.put("rownm", "순번");
		headerMap.put("orderNo", "주문번호");
		headerMap.put("estNo", "견적번호");
		headerMap.put("paymentNo", "결제번호");
		headerMap.put("ctrtNm", "계약명");
		headerMap.put("etpSttsNm", "진행상태");
		headerMap.put("companyName", "회사명");
		headerMap.put("userType", "계정권한");
		headerMap.put("userName", "주문사용자");
		headerMap.put("regDtime", "최초요청일자");
		headerMap.put("orderDate", "주문일자");
		
		// 3. 파일명 설정 
		String fileName = "견적_주문_구매_결제_관리_이력_리스트_" + System.currentTimeMillis();
		
		// 4. 공통 모듈 호출
		excelService.downloadExcel(response, fileName, headerMap, dataList);
	}

}
