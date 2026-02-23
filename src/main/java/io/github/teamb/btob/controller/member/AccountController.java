package io.github.teamb.btob.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.service.account.UserInfoService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/account")
public class AccountController {
	
    private final UserInfoService userInfoService;

    
    /**
     * [API] 회원가입 처리
     */
    @PostMapping("/api/register")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> register(@RequestBody UserInfoRegisterRequestDTO registerDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            log.info("회원가입 요청: {}", registerDTO.getInsertUserInfo().getUserId());
            userInfoService.registerUserInfo(registerDTO);
            
            response.put("success", true);
            response.put("message", "회원가입이 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("회원가입 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * 
     * [API] 셀렉박스 리스트만 별도로 필요할 경우 (비동기 호출용)
     * @author GD
     * @since 2026. 2. 23.
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 23.  GD       최초 생성
     */
    @GetMapping("/api/select-boxes")
    @ResponseBody
    public ResponseEntity<Map<String, List<SelectBoxVO>>> getSelectBoxes() {
    	
        return ResponseEntity.ok(userInfoService.registerCompanySelectBoxList());
    }

    /**
     * [API] 아이디 찾기
     * (제공해주신 서비스에는 없으나 모달 구현을 위해 구조 생성)
     */
    @PostMapping("/api/find-id")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> findId(@RequestBody Map<String, String> data) {
        Map<String, Object> response = new HashMap<>();
        // TODO: 서비스에 findId(userName, email/phone) 구현 필요
        response.put("success", true);
        response.put("message", "입력하신 정보로 등록된 아이디를 이메일로 전송했습니다.");
        return ResponseEntity.ok(response);
    }

    /**
     * [API] 비밀번호 재설정/찾기 요청
     */
    @PostMapping("/api/find-pw")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> findPw(@RequestBody Map<String, String> data) {
        Map<String, Object> response = new HashMap<>();
        // TODO: 임시 비밀번호 발급 또는 재설정 링크 메일 발송 로직 필요
        response.put("success", true);
        response.put("message", "비밀번호 재설정 안내가 메일로 발송되었습니다.");
        return ResponseEntity.ok(response);
    }
}
