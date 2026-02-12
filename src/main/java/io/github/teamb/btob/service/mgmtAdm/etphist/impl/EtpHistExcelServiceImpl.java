package io.github.teamb.btob.service.mgmtAdm.etphist.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.mgmtAdm.hist.SearchEtpHistListDTO;
import io.github.teamb.btob.mapper.mgmtAdm.EtpHistMgmtAdmMapper;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.mgmtAdm.etphist.EtpHistExcelService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EtpHistExcelServiceImpl implements EtpHistExcelService {
	
	private final EtpHistMgmtAdmMapper etpHistMgmtAdmMapper;
	private final ExcelService excelService;

	
	/**
	 * 
	 * 히스토리 이력 조회 자료 엑셀 다운로드
	 * @author GD
	 * @since 2026. 2. 10.
	 * @param response 
	 * @param params ( 검색 조건식 )
	 * @throws Exception
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 10.  GD       최초 생성
	 */
	@Override
	public void downloadEtpHistExcel(HttpServletResponse response, Map<String, Object> params) throws Exception {
		
				// 1. DB에서 데이터 조회
				List<SearchEtpHistListDTO> dataList = etpHistMgmtAdmMapper.selectEtpHistSearchConditioinListAdm(params);
				
				// 2. 엑셀 헤더 설정 (LinkedHashMap을 써야 넣은 순서대로 엑셀 컬럼이 생깁니다)
				Map<String, String> headerMap = new LinkedHashMap<String, String>();
				headerMap.put("rownm", "순번");
				headerMap.put("etpId", "주문번호");
				headerMap.put("etpSttsNm", "의사결정단계");
				headerMap.put("requestUserNm", "요청자");
				headerMap.put("regDtime", "요청일자");
				headerMap.put("apprUserNm", "승인자");
				headerMap.put("apprDtime", "승인/반려일자");
				headerMap.put("rejtRsn", "반려사유");
				
				// 3. 파일명 설정 
				String fileName = "히스토리_이력_리스트_" + System.currentTimeMillis();
				
				// 4. 공통 모듈 호출
				excelService.downloadExcel(response, fileName, headerMap, dataList);
		}
		
}
