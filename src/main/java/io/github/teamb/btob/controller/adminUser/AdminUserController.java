package io.github.teamb.btob.controller.adminUser;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.user.UserDTO;
import io.github.teamb.btob.service.adminUser.AdminUserService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/user")
@RequiredArgsConstructor
public class AdminUserController {

	private final AdminUserService adminUserService;
	
	// 사용자 관리 리스트 페이지 
	@GetMapping("/list")
	public String adminUserList(@RequestParam(required = false) String viewType, Model model) { // viewType이 없으면 null(전체리스트)
		
		model.addAttribute("adminUserList", adminUserService.getUserList());
		model.addAttribute("viewType", viewType);
		model.addAttribute("content", "adminsh/adminUser/adminUserList.jsp");
		
		return "layout/layout";
	}
	
	// 대표 가입 승인 처리
	@PostMapping("/approveCompany")
	@ResponseBody
	public String approveCompany(@RequestParam String userId) {
		
		return adminUserService.approveCompany(userId) ? "OK" : "FAIL";
	}
	
	// 계정 상태 변경
	@PostMapping("/modifyUserStatus")
	@ResponseBody
	public String modifyUserStatus(@RequestParam String userId, @RequestParam String accStatus) {
		
		return adminUserService.modifyUserStatus(userId, accStatus) ? "OK" : "FAIL";
	}
	
	// 신규 관리자 등록
	@GetMapping("/register")
	public String register(Model model) {
		
		model.addAttribute("content",  "adminsh/adminUser/adminUserForm.jsp");
		return "layout/layout";
	}
	@PostMapping("/registerAdminUser")
	@ResponseBody
	public String register(UserDTO userDTO) {
		
		return adminUserService.registerAdminUser(userDTO) ? "OK" : "FAIL";
	}
	
	@GetMapping("/checkDuplicateId")
	@ResponseBody
	public boolean checkDuplicateId(@RequestParam String userId) {
		
		return adminUserService.isIdDuplicate(userId);
	}
}
