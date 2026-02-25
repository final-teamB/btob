package io.github.teamb.btob.controller.user;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.common.ExcelUploadResult;
import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.dto.user.UserListDTO;
import io.github.teamb.btob.dto.user.UserPendingActionDTO;
import io.github.teamb.btob.dto.user.UserPendingDTO;
import io.github.teamb.btob.dto.user.UserStatusDTO;
import io.github.teamb.btob.service.excel.ExcelService;
import io.github.teamb.btob.service.user.UserService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserManagementController {
	private final UserService userService;
	private final LoginUserProvider loginUserProvider;
	private final ExcelService excelService;

    // 전체 사원 목록 페이지
    @GetMapping("/test")
    public String test(
    		@RequestParam(required = false) String accStatus,
    		@RequestParam(required = false) String keyword,
    		Model model) {
    	
    	List<UserListDTO> userList = userService.getUserList(accStatus, keyword);
    	
    	model.addAttribute("userList", userList);
    	model.addAttribute("pageTitle", "사원리스트");  
    	model.addAttribute("content", "users/test.jsp"); 
    	return "layout/layout";
    }
    
    
    @GetMapping("/pendingCount")
    @ResponseBody
    public int getPendingUserCount() {
         int userNo = loginUserProvider.getLoginUserNo();
    	 int count = userService.getPendingUserCount(userNo);
        return count;
    }
    
    // 전체 사원 목록 페이지
    @GetMapping("/list")
    public String userList(
    		@RequestParam(required = false) String accStatus,
    		@RequestParam(required = false) String keyword,
    		Model model) {
    	
    	List<UserListDTO> userList = userService.getUserList(accStatus, keyword);
    	
    	model.addAttribute("userList", userList);
    	model.addAttribute("pageTitle", "사원리스트");  
    	model.addAttribute("content", "users/list.jsp"); 
    	return "layout/layout";
    }
    
    // 회원가입 승인 대기자 목록 페이지
    @GetMapping("/pending")
    public String pendingUsers(Model model) {
    	List<UserPendingDTO> pendingList = userService.getPendingUsers();
       
    	model.addAttribute("pendingList", pendingList);
    	model.addAttribute("pageTitle", "회원가입 승인 대기 목록");  
        model.addAttribute("content", "users/pending.jsp"); 
        return "layout/layout"; 
    }

   
    // 회원가입 승인/거부 
    @PostMapping("/pendingAction")
    public String pedingAction(UserPendingActionDTO upa) {
        userService.processPendingUser(upa);    
        return "redirect:/users/pending"; 
    }

    // 사원 상태 수정
    @PostMapping("/modifyStatus")
    public ResponseEntity<?> modifyStatus(UserStatusDTO userStatus) {
        userService.modifyUserStatus(userStatus);
        return ResponseEntity.ok().build();
    }
    
    // 양식 다운로드 
    @GetMapping("/downloadTemplate")
    public void downloadTemplate(
            @RequestParam(defaultValue = "user_template.xlsx") String fileName, 
            HttpServletResponse response) throws Exception {
        // 서비스에서 처리하는 파일명과 맞춤
        excelService.downloadExcelTemplate(response, fileName);
    }

    // 사원 엑셀 업로드 (AJAX 전용)
    @PostMapping("/upload-ajax")
    @ResponseBody // 결과를 JSON으로 반환하기 위해 필수!
    public ResponseEntity<ExcelUploadResult<UserDTO>> uploadUsersAjax(
            @RequestParam("file") MultipartFile file) {

        ExcelUploadResult<UserDTO> result = new ExcelUploadResult<>();

        try {
            // 1) 엑셀 읽기 및 검증
            result = userService.readExcel(file);
       
            // 2) 실패가 없을 경우에만 DB 커밋 (로직은 기존과 동일)
            if (result.getFailCount() == 0 && !result.getSuccessList().isEmpty()) {
                int insertedCount = userService.commitExcel(result.getSuccessList());
                // 성공 건수를 DTO에 세팅하거나 로그 출력
                result.setSuccessCount(insertedCount); 
            }
            
            // 성공/실패 결과가 담긴 DTO를 JSON으로 반환
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 발생 시 500 에러와 함께 빈 결과 전달
            return ResponseEntity.status(500).body(null);
        }
    }
    
	
}
