package io.github.teamb.btob.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
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
    private final LoginUserProvider loginUserProvider;

    
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
     * 
     * [API] 아이디 찾기
     * (제공해주신 서비스에는 없으나 모달 구현을 위해 구조 생성)
     * @author GD
     * @since 2026. 2. 24.
     * @param data
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
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
     * 
     * [API] 비밀번호 재설정/찾기 요청
     * @author GD
     * @since 2026. 2. 24.
     * @param data
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
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
    
    /**
     * 
     * 마이페이지 화면 이동
     * @author GD
     * @since 2026. 2. 24.
     * @param model
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @GetMapping("/mypage")
    public String myPage(Model model) {
        // 1. 현재 로그인한 사용자 ID 가져오기
        String loginUserId = loginUserProvider.getLoginUserId();
        
        if (loginUserId == null || loginUserId.isEmpty()) {
            // 로그인 정보가 없으면 로그인 페이지로 튕기거나 에러 처리
            return "redirect:/login";
        }

        // 2. 서비스 레이어를 통해 사용자 정보 조회 (회사 정보 포함)
        UserInfoDTO userInfo = userInfoService.getUserInfoById(loginUserId);
        
        // 3. 화면에 데이터 전달
        model.addAttribute("userInfo", userInfo);
        // 4. 셀렉박스 데이터 (직급이나 권한 변경 시 필요할 수 있음)
        model.addAttribute("selectBoxList", userInfoService.registerCompanySelectBoxList());
        // 5. 레이아웃 설정
        model.addAttribute("content", "account/myInfo.jsp");
        
        return "layout/layout";
    }

    /**
     * 
     * [API] 개인정보 수정 처리
     * @author GD
     * @since 2026. 2. 24.
     * @param modifyDTO
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/modify")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> modifyUserInfo(@RequestBody UserInfoModifyRequestDTO modifyDTO) {
        Map<String, Object> response = new HashMap<>();
        try {
            log.info("개인정보 수정 요청: {}", loginUserProvider.getLoginUserId());
            userInfoService.modifyUserInfo(modifyDTO);
            
            response.put("success", true);
            response.put("message", "정보 수정이 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("정보 수정 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    /**
     * 
     * 비밀번호 변경 API
     * @author GD
     * @since 2026. 2. 24.
     * @param dto 사용자가 입력한 현재/신규 비밀번호 정보
     * @return 성공 여부 및 결과 메시지
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/updatePassword")
    @ResponseBody
    public Map<String, Object> updatePassword(@RequestBody UserInfoDTO dto) {
        Map<String, Object> result = new HashMap<>();
        
        // 1. 기초적인 파라미터 유효성 검사 (서버 부하 방지)
        if (dto.getPreviousPassword() == null || dto.getPreviousPassword().isEmpty() ||
            dto.getNewPassword() == null || dto.getNewPassword().isEmpty()) {
            result.put("success", false);
            result.put("message", "입력 정보가 누락되었습니다.");
            return result;
        }

        try {
            // 2. 서비스 호출 
            // 서비스 내부에서 암호화, 현재 비번 체크, 로그인 사용자 검증을 모두 수행합니다.
            Integer updateCount = userInfoService.modifyUserPassword(
                dto.getPreviousPassword(), 
                dto.getNewPassword()
            );
            
            // 3. 결과 응답 처리
            if (updateCount != null && updateCount > 0) {
                result.put("success", true);
                result.put("message", "비밀번호가 안전하게 변경되었습니다. 보안을 위해 다시 로그인해주세요.");
            } else {
                result.put("success", false);
                result.put("message", "비밀번호 변경에 실패하였습니다. 다시 시도해주세요.");
            }
            
        } catch (Exception e) {
            // 서비스에서 던진 구체적인 메시지(예: "현재 비밀번호가 일치하지 않습니다.")를 그대로 전달
            result.put("success", false);
            result.put("message", e.getMessage()); 
            
            // 시스템 에러 로그 기록
            log.error("[PasswordChangeError] User: {} | Message: {}", dto.getUserId(), e.getMessage());
        }
        
        return result;
    }
}
