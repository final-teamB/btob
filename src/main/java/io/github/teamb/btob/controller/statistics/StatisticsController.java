package io.github.teamb.btob.controller.statistics;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.statistics.OrderStatisticsDTO;
import io.github.teamb.btob.service.statistics.StatisticsService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/stats")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class StatisticsController {
	
	private final StatisticsService statisticsService;
	
	// 종합 대시보드 (메인)
    @GetMapping("/main")
    public String statisticsMain() {
        return "test/statistics/stats"; // 종합 화면용 JSP
    }
	
	// 1. 주문 현황 
	@GetMapping("/order")
	public String orderStatsPage() {
		return "test/statistics/statsOrder"; // 생성하신 JSP 경로에 맞춰주세요
	}
	
	@GetMapping("/order/excel")
	public void downloadOrderExcel(HttpServletResponse httpServletResponse) throws Exception {
		List<OrderStatisticsDTO> list = statisticsService.getOrderStats();
		
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("new Sheet");
		
		Row headerRow = sheet.createRow(0);
		
		headerRow.createCell(0).setCellValue("날짜");
		headerRow.createCell(1).setCellValue("총 주문 수");
		
		int rowNum = 1;
		for(OrderStatisticsDTO dto : list) {
			Row row = sheet.createRow(rowNum);
			row.createCell(0).setCellValue(dto.getExecutedAt().toString());
			row.createCell(1).setCellValue(dto.getTotalOrderCount());
		}
		
		httpServletResponse.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	
		httpServletResponse.setHeader("Content-Disposition", "attachment; filename=order_stats.xlsx");
		try {
			workbook.write(httpServletResponse.getOutputStream()); 
	        workbook.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 2. 배송 현황 
	@GetMapping("/delivery")
	public String deliveryStatsPage() {
		return "test/statistics/statsDelivery";
	}
	
	// 3. 사용자 통계 \
	@GetMapping("/user")
	public String userStatsPage() {
		return "test/statistics/statsUser";
	}
	
	// 4. 상품 통계 
	@GetMapping("/product")
	public String productStatsPage() {
		return "test/statistics/statsProduct";
	}
	
	// 차트 데이터 JSON 반환 (모든 JSP에서 공통 사용)
	@GetMapping("/data")
	@ResponseBody 
	public Map<String, Object> getChartData() {
		Map<String, Object> chartData = new HashMap<>();
		
		chartData.put("orderStats", statisticsService.getOrderStats());
		chartData.put("deliveryStats", statisticsService.getStatsByType("DELIVERY"));
        chartData.put("userStats", statisticsService.getStatsByType("USER"));
        chartData.put("productStats", statisticsService.getStatsByType("PRODUCT"));
        
        return chartData;
	}
	
	// 데이터 최신화 
	@PutMapping("/refresh")
	@ResponseBody
	public String refreshData() {
		try {
			statisticsService.refreshOrderStats(1);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
}