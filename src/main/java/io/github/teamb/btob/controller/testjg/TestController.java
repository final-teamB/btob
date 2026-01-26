package io.github.teamb.btob.controller.testjg;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import io.github.teamb.btob.dto.testjg.UserExcelResult;
import io.github.teamb.btob.service.testjg.UsersService;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/testjg")
public class TestController {
    private final UsersService usersService;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Value("${toss.secret-key}")
    private String tossSk;
    
    @Value("${toss.client-key}")
    private String tossCk;
	
    public TestController(UsersService usersService) {;
		this.usersService = usersService;
	}

	  @GetMapping("/test")
	    public String testPage(Model model) {
		  model.addAttribute("tossCk", tossCk);
	        return "testjg/test"; // JSP 호출
	    }
	  	
	
	    @PostMapping("/test")
	    public String uploadExcel(@RequestParam("file") MultipartFile file, Model model) {
	        try {
	        	 UserExcelResult result = usersService.readExcel(file);
	            int count = usersService.commitExcel(result.getSuccessList());
	            model.addAttribute("msg", count + "명의 사원이 DB에 추가되었습니다.");
	            model.addAttribute("failList", result.getFailList());
	        } catch(Exception e) {
	            model.addAttribute("msg", "업로드 실패: " + e.getMessage());
	        }
	        return "test"; // JSP: 결과 페이지
	    }
	  
	    @GetMapping("/pdf")
	    public String pdfPage() {
	    	return "testjg/pdf"; // JSP 호출
	    }
	    
	    @GetMapping("/pdfDown")
	    public void pdfDown(HttpServletResponse response) throws Exception {

	        response.setContentType("application/pdf");
	        String fileName = "estimate.pdf";
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

	        // 1. 파일 읽기 (경로 주의: 프로젝트 구조에 따라 수정 필요할 수 있음)
	        String html = Files.readString(
	            Path.of("src/main/webapp/WEB-INF/views/testjg/pdf.jsp"), 
	            StandardCharsets.UTF_8
	        );

	        // 2. JSP 태그 제거 및 기본 HTML 구조 보강
	        html = html.replaceAll("<%@.*%>", "").trim();
	        html = html.replace("</head>", "<style>body { font-family: 'NanumGothic'; }</style></head>");

	        PdfRendererBuilder builder = new PdfRendererBuilder();
	        builder.withHtmlContent(html, null);

	        ClassPathResource fontResource = new ClassPathResource("fonts/NanumGothic.ttf");

	        builder.useFont(() -> {
	            try {
	                return fontResource.getInputStream();
	            } catch (IOException e) {
	                // 여기서 예외를 런타임 예외로 감싸서 던져야 에러가 안 납니다.
	                throw new RuntimeException("폰트 파일을 찾을 수 없습니다: " + e.getMessage());
	            }
	        }, "NanumGothic");

	        // 4. OutputStream 사용 (자동으로 닫히도록 try문에 선언)
	        try (OutputStream os = response.getOutputStream()) {
	            builder.toStream(os);
	            builder.run();
	        }
	    }
	    
	    @GetMapping("/payment")
	    public String paymentPage(Model model) {
	        // 환경변수에서 클라이언트 키를 읽어서 넘겨줍니다.
	        model.addAttribute("tossCk", tossCk); 
	        return "testjg/payment"; 
	    }
	    
	    @GetMapping("/tossSuccess")
	    public String paymentSuccess(
	            @RequestParam String paymentKey,
	            @RequestParam String orderId,
	            @RequestParam int amount,
	            Model model) throws Exception {

	        URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

	        String auth = Base64.getEncoder().encodeToString((tossSk + ":").getBytes(StandardCharsets.UTF_8));
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Authorization", "Basic " + auth);
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setDoOutput(true);

	        String jsonBody = String.format(
	            "{\"paymentKey\":\"%s\",\"orderId\":\"%s\",\"amount\":%d}",
	            paymentKey, orderId, amount
	        );

	        try (OutputStream os = conn.getOutputStream()) {
	            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
	        }

	        int responseCode = conn.getResponseCode();
	        ObjectMapper objectMapper = new ObjectMapper();
	        JsonNode responseNode;

	        if (responseCode == 200) {
	            responseNode = objectMapper.readTree(conn.getInputStream());
	            // null 방지를 위해 path() 사용 (get()보다 안전합니다)
	            String status = responseNode.path("status").asText();

	            if ("DONE".equals(status)) {
	            	// 카드, 실시간 계좌이체 등 즉시 결제 완료인 경우
	                model.addAttribute("msg", "결제가 최종 완료되었습니다!");
	                model.addAttribute("isSuccess", true); // 완료 상태 구분용
	            } 
	            else if ("WAITING_FOR_DEPOSIT".equals(status)) {
	            	// 가상계좌 발급 시 (아직 돈 안 들어옴)
	                JsonNode virtualAccount = responseNode.path("virtualAccount");
	                
	                if (!virtualAccount.isMissingNode()) {
	                    String accountNumber = virtualAccount.path("accountNumber").asText();
	                    String bank = virtualAccount.path("bank").asText();
	                    String dueDate = virtualAccount.path("dueDate").asText();

	                    model.addAttribute("msg", "가상계좌가 발급되었습니다. 아래 계좌로 입금해주세요.");
	                    model.addAttribute("accountInfo", bank + " " + accountNumber);
	                    model.addAttribute("dueDate", dueDate);
	                    model.addAttribute("isWaiting", true); // 대기 상태 구분용
	                } else {
	                    model.addAttribute("msg", "가상계좌 정보가 응답에 포함되지 않았습니다.");
	                }
	            }
	            model.addAttribute("paymentData", responseNode.toString());
	        } else {
	            responseNode = objectMapper.readTree(conn.getErrorStream());
	            model.addAttribute("msg", "결제 승인 실패: " + responseNode.path("message").asText());
	        }

	        model.addAttribute("paymentKey", paymentKey);
	        model.addAttribute("orderId", orderId);
	        model.addAttribute("amount", amount);
	        
	        return "testjg/tossSuccess";
	    }
	    
	    @GetMapping("/tossFail")
	    public String paymentFail() {
	        return "testjg/tossFail";
	    }
	    
	    	
}
