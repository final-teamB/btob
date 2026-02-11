package io.github.teamb.btob.controller.adminstatistics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.adminStatistics.OrderStatisticsDTO;
import io.github.teamb.btob.service.adminStatistics.StatisticsService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/stats")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@PreAuthorize("hashRole('ADMIN')")
public class StatisticsController {
    
    private final StatisticsService statisticsService;
    private final JobLauncher jobLauncher;
    private final Job refreshOrderStatsJob;
    
    // 레이아웃 적용 공통 메서드
    private String renderLayout(Model model, String contentPath, String title) {
        model.addAttribute("content", "adminsh/adminStatistics/" + contentPath); // 실제 jsp 파일명
        model.addAttribute("pageTitle", title);
        return "layout/layout"; 
    }

    // 종합 대시보드
    @GetMapping("/main")
    public String statisticsMain(Model model) {
        return renderLayout(model, "stats.jsp", "통계 대시보드");
    }
    
    // 주문 현황 
    @GetMapping("/order")
    public String orderStatsPage(Model model) {
        return renderLayout(model, "statsOrder.jsp", "주문 현황 분석");
    }
    
    // 배송 현황 
    @GetMapping("/delivery")
    public String deliveryStatsPage(Model model) {
        return renderLayout(model, "statsDelivery.jsp", "배송 현황 분석");
    }
    
    // 사용자 분석
    @GetMapping("/user")
    public String userStatsPage(Model model) {
        return renderLayout(model, "statsUser.jsp", "사용자 지표 분석");
    }
    
    // 상품 분석 
    @GetMapping("/product")
    public String productStatsPage(Model model) {
        return renderLayout(model, "statsProduct.jsp", "상품 재고 분석");
    }

    // --- 데이터 API (@ResponseBody) ---
    
    // 주문 통계 엑셀 다운로드
    @GetMapping("/order/excel")
    public void downloadOrderExcel(HttpServletResponse httpServletResponse) throws Exception {
        List<OrderStatisticsDTO> list = statisticsService.getOrderStats();
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Order Statistics");
        
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("날짜");
        headerRow.createCell(1).setCellValue("총 주문 수");
        
        int rowNum = 1;
        for(OrderStatisticsDTO dto : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(dto.getExecutedAt().toString());
            row.createCell(1).setCellValue(dto.getTotalOrderCount());
        }
        
        httpServletResponse.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        httpServletResponse.setHeader("Content-Disposition", "attachment; filename=order_stats.xlsx");
        workbook.write(httpServletResponse.getOutputStream()); 
        workbook.close();
    }

    // 차트 데이터 조회 API
    // -- 주문, 배송, 사용자, 상품 통계 한 번에 map으로 반환
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

    @GetMapping("/delivery-full-data")
    @ResponseBody
    public Map<String, Object> getDeliveryFullData() {
        Map<String, Object> result = new HashMap<>();
        result.put("kpi", statisticsService.getDeliveryKPI());
        
        result.put("status", statisticsService.getDeliveryStatusCounts());
        
        result.put("region", statisticsService.getDeliveryRegionStats());
        
        Object gridList = statisticsService.getRecentDeliveryList(null, null);
        result.put("gridList", gridList != null ? gridList : new ArrayList<>());
        
        return result;
    }
    
    @GetMapping("/delivery-list-filtered")
    @ResponseBody
    public List<Map<String, Object>> getFilteredDeliveryList(
            @RequestParam(required = false) String type, 
            @RequestParam(required = false) String value) {
        return statisticsService.getRecentDeliveryList(type, value);
    }

    @GetMapping("/user-full-data")
    @ResponseBody
    public Map<String, Object> getUserFullData() {
        return statisticsService.getUserFullData();
    }
    
    @GetMapping("/user-list-filtered")
    @ResponseBody
    public List<Map<String, Object>> getFilteredUserList(
            @RequestParam String type, 
            @RequestParam(required = false) String value) {
        return statisticsService.getFilteredUserList(type, value);
    }

    @GetMapping("/product-full-data")
    @ResponseBody
    public Map<String, Object> getProductFullData() {
        return statisticsService.getProductFullData();
    }
    
    @GetMapping("/product-list-filtered")
    @ResponseBody
    public List<Map<String, Object>> getProductList(
            @RequestParam(value="type", required=false, defaultValue="all") String type,
            @RequestParam(value="value", required=false, defaultValue="") String value) {
        
        return statisticsService.getFilteredProductList(type, value);
    }

    // 데이터 스냅샷
    @RequestMapping(value = "/snapshot", method = {RequestMethod.GET, RequestMethod.PUT})
    @ResponseBody
    public Map<String, Object> takeFullSnapshot(@AuthenticationPrincipal UserDetails userDetails) {
        Map<String, Object> response = new HashMap<>();
        try {
        	String adminId = userDetails.getUsername();
            statisticsService.saveAllDailySnapshots(adminId); 
            response.put("result", "SUCCESS");
            response.put("message", "데이터 스냅샷 저장 완료");
        } catch (Exception e) {
            response.put("result", "FAIL");
            response.put("message", e.getMessage());
        }
        return response;
    }

    // 주문 통계 최신화버튼
    @PutMapping("/refresh")
    @ResponseBody
    public String refreshData(@AuthenticationPrincipal UserDetails userDetails) {
    	if (userDetails == null) {
            System.out.println("❌ 에러: 로그인 정보가 없습니다.");
            return "error_no_auth";
        }
    	
    	try {
        	String adminId = userDetails.getUsername();
        	System.out.println("🚀 배치 실행 요청자: " + adminId);
        	
            JobParameters params = new JobParametersBuilder()
                    .addLong("timestamp", System.currentTimeMillis())
                    .addString("executedBy", adminId)
                    .toJobParameters();
            jobLauncher.run(refreshOrderStatsJob, params);
            
            return "success";
        } catch (Exception e) {
            return "error";
        }
    } 
}