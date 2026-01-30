package io.github.teamb.btob.controller.user;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.teamb.btob.dto.common.ExcelUploadResult;
import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.dto.user.UserListDTO;
import io.github.teamb.btob.dto.user.UserPendingActionDTO;
import io.github.teamb.btob.dto.user.UserPendingDTO;
import io.github.teamb.btob.dto.user.UserStatusDTO;
import io.github.teamb.btob.service.user.UserService;

@Controller
@RequestMapping("/users")
public class UserManagementController {
	private final UserService userService;

	public UserManagementController(UserService userService) {
		this.userService = userService;
	}
	
    // 전체 사원 목록 페이지
    @GetMapping("/list")
    public String userList(
    		@RequestParam(required = false) String accStatus,
            @RequestParam(required = false) String keyword,
            Model model) {
    	
    	List<UserListDTO> userList = userService.getUserList(accStatus, keyword);
        model.addAttribute("userList", userList);
        return "users/list";
    }
    
    // 전체 사원 목록 페이지
    @GetMapping("/test")
    public String test(
    		@RequestParam(required = false) String accStatus,
    		@RequestParam(required = false) String keyword,
    		Model model) {
    	
    	List<UserListDTO> userList = userService.getUserList(accStatus, keyword);
    	model.addAttribute("userList", userList);
    	
    	model.addAttribute("showAddBtn", true);         // 등록 버튼 노출
    	model.addAttribute("pageTitle", "사원리스트");  
    	model.addAttribute("content", "users/test.jsp"); 
    	return "layout/layout";
    }
    
    // 회원가입 승인 대기자 목록 페이지
    @GetMapping("/pending")
    public String pendingUsers(Model model) {
    	List<UserPendingDTO> pendingList = userService.getPendingUsers();
        model.addAttribute("pendingList", pendingList);
       
        return "users/pending"; 
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
    
    // 사원 엑셀 다운로드
    @PostMapping("/upload")
    public String uploadUsers(
            @RequestParam("file") MultipartFile file,
            RedirectAttributes ra) {

        ExcelUploadResult<UserDTO> result;

        try {
            result = userService.readExcel(file);
       
            // ❗ 실패가 하나라도 있으면 저장 안 함
            if (result.getFailCount() > 0) {
                ra.addFlashAttribute("error", "엑셀 검증에 실패하여 등록이 취소되었습니다. (오류 " + result.getFailCount() + "건)");

                ra.addFlashAttribute("failList", result.getFailList());
                return "redirect:/users/list";
            }
            
            int insertedCount = userService.commitExcel(result.getSuccessList());
            ra.addFlashAttribute("insertedCount", insertedCount);

        } catch (Exception e) {
            ra.addFlashAttribute("error", "엑셀 처리 중 오류 발생");
        }

        return "redirect:/users/list";
    }
	
}
