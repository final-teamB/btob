package io.github.teamb.btob.controller.testjg;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.testjg.UserExcelResult;
import io.github.teamb.btob.service.testjg.TestService;
import io.github.teamb.btob.service.testjg.UsersService;

@Controller
public class TestController {
    private final TestService testService;
    private final UsersService usersService;
	
	  public TestController(TestService testService, UsersService usersService) {;
		this.testService = testService;
		this.usersService = usersService;
	}

	  @GetMapping("/test/test")
	    public String testPage() {
	        return "test/test"; // JSP 호출
	    }
	  	
	
	    @PostMapping("/test/test")
	    public String uploadExcel(@RequestParam("file") MultipartFile file, Model model) {
	        try {
	        	 UserExcelResult result = usersService.readExcel(file);
	            int count = usersService.commitExcel(result.getSuccessList());
	            model.addAttribute("msg", count + "명의 사원이 DB에 추가되었습니다.");
	            model.addAttribute("failList", result.getFailList());
	        } catch(Exception e) {
	            model.addAttribute("msg", "업로드 실패: " + e.getMessage());
	        }
	        return "test/test"; // JSP: 결과 페이지
	    }
	  
	    @PostMapping("/test/pdf")
	    @ResponseBody
	    public String createPdf(@RequestBody List<Map<String, Object>> selectedRows) {
	        try {
	        	testService.createPdfFromGrid(selectedRows, "/tmp/test_selected.pdf");
	            return "PDF 생성 완료! (/tmp/test_selected.pdf)";
	        } catch (Exception e) {
	            return "실패: " + e.getMessage();
	        }
	    }

	    @PostMapping("/test/toss")
	    @ResponseBody
	    public String tossPayment(@RequestBody List<Map<String, Object>> selectedRows) {
	        // TODO: 토스 샌드박스 API 호출
	        return "토스 결제 테스트 완료! 선택 상품 수: " + selectedRows.size();
	    }

	    @PostMapping("/test/kakao")
	    @ResponseBody
	    public String kakaoPayment(@RequestBody List<Map<String, Object>> selectedRows) {
	        // TODO: 카카오 샌드박스 API 호출
	        return "카카오페이 테스트 완료! 선택 상품 수: " + selectedRows.size();
	    }	
}
