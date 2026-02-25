package io.github.teamb.btob.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.account.EmailAuthDTO;
import io.github.teamb.btob.dto.account.FindRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoDTO;
import io.github.teamb.btob.dto.account.UserInfoModifyRequestDTO;
import io.github.teamb.btob.dto.account.UserInfoRegisterRequestDTO;
import io.github.teamb.btob.dto.common.SelectBoxVO;
import io.github.teamb.btob.service.account.EmailService;
import io.github.teamb.btob.service.account.UserInfoService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/account")
public class AccountController {
	
    private final UserInfoService userInfoService;
    private final EmailService emailService;
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
     * * [API] 회원가입 시 아이디 중복 체크
     * @author GD
     * @since 2026. 2. 25.
     * @param userId
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 25.  GD       최초 생성
     */
    @GetMapping("/api/check-duplicate-id")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkUserIdDuplication(@RequestParam("userId") String userId) {
        
    	Map<String, Object> response = new HashMap<>();
        
        try {
            // 파라미터 유효성 검사 (공백 등)
            if (userId == null || userId.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "아이디를 입력해주세요.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            // 서비스 호출 (중복 시 Exception 발생)
            userInfoService.userIdDuplicationChk(userId);
            
            response.put("success", true);
            response.put("message", "사용 가능한 아이디입니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            // 서비스에서 던진 "중복된 ID로 사용이 불가능합니다." 메시지가 잡힘
            log.warn("아이디 중복 체크 결과: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
            // 중복은 클라이언트 입장에서 에러가 아닌 '체크 결과'이므로 200 OK로 보내거나 409 Conflict를 사용합니다.
            // 여기서는 프론트 로직 편의상 200(OK)으로 응답하되 success를 false로 줍니다.
            return ResponseEntity.ok(response);
        }
    }
    
    /**
     * 
     * [API] 인증번호 발송
     * @author GD
     * @since 2026. 2. 24.
     * @param authDTO
     * @param session
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/send-auth-num")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendAuthNum(
										    		@RequestBody EmailAuthDTO authDTO, 
										    		HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
        	
        	boolean isExist = false;
        	boolean isExistBan = false;
            String type = authDTO.getType(); // "ID" 또는 "PW"

            // [수정] 타입에 따른 서비스 분기 처리
            if ("ID".equals(type)) {
                // 아이디 찾기: 이름 + 이메일 체크
                isExist = userInfoService.checkUserExists(authDTO.getUserName(), authDTO.getEmail());
                isExistBan = userInfoService.checkUserBanExists(authDTO.getUserName(), authDTO.getEmail());
            } else if ("PW".equals(type)) {
                // 비밀번호 찾기: 이름 + 아이디 + 이메일 체크
                isExist = userInfoService.checkUserPwExists(authDTO.getUserName(), authDTO.getUserId(), authDTO.getEmail());
                isExistBan = userInfoService.checkUserBanPwExists(authDTO.getUserName(), authDTO.getUserId(), authDTO.getEmail());
            }
            
            if (!isExist) {
                response.put("success", false);
                // 비밀번호 찾기 시 아이디 정보까지 확인하라는 메시지 추가
                String msg = "ID".equals(type) ? "이름과 이메일을 다시 확인해주세요." : "이름, 아이디, 이메일을 다시 확인해주세요.";
                response.put("message", "일치하는 사용자 정보가 없습니다. " + msg);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            // 서비스가 정상이면 true, 밴이면 false를 리턴하므로 
            // !isExistBan 즉, false(밴 상태)일 때 이 블록이 실행되어야 합니다.
            if (!isExistBan) {
                response.put("success", false);
                // 비밀번호 찾기 시 아이디 정보까지 확인하라는 메시지 추가
                String msg = "해당 사용자는 계정상태가 밴처리 상태입니다. 문의사항은 관리자에게 요청해주세요";
                response.put("message", msg);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }
        	
            // 메일 발송 시도 (검증 통과 시에만 실행)
            String generatedNum = emailService.sendAuthMail(authDTO.getEmail(), authDTO.getType());
            
            // 2. 세션에 정보 저장 (인증번호, 이메일, 발송시간)
            session.setAttribute("authNum_" + type, generatedNum);
            session.setAttribute("authEmail_" + type, authDTO.getEmail());
            session.setAttribute("authTime_" + type, System.currentTimeMillis()); // [추가] 생성 시간 기록
            
            // 세션 유지 시간 설정 (필요시)
            session.setMaxInactiveInterval(600); // 10분 정도가 적당합니다 (3분 인증 대기 고려)
            
            response.put("success", true);
            response.put("message", "인증번호가 발송되었습니다. 메일함을 확인해주세요.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            // 서비스에서 던진 "메일 발송 중 오류..." 메시지가 사용자에게 전달됨
        	// [수정] 상세한 에러 로그는 서버 콘솔에만 찍고
            log.error("인증번호 발송 에러 발생: ", e);
            response.put("success", false);
            // [수정] 사용자에게는 정제된 메시지만 보여줍니다.
            String errorMsg = (e.getMessage() != null) ? e.getMessage() : "시스템 오류가 발생했습니다.";
            response.put("message", errorMsg); 
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 
     * [API] 인증번호 검증
     * @author GD
     * @since 2026. 2. 24.
     * @param authDTO
     * @param session
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/verify-auth-num")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyAuthNum(
													    		@RequestBody EmailAuthDTO authDTO, 
													    		HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
        	
        	// [추가] 시간 만료 체크 (3분 = 180,000ms)
            Long sendTime = (Long) session.getAttribute("authTime_" + authDTO.getType());
            if (sendTime == null || (System.currentTimeMillis() - sendTime) > 180000) {
                throw new Exception("인증 시간이 만료되었습니다. 다시 시도해주세요.");
            }
        	
            String serverNum = (String) session.getAttribute("authNum_" + authDTO.getType());
            
            // 검증 로직 호출 (성공하면 true, 실패하면 Exception 발생)
            emailService.verifyAuthNum(authDTO.getAuthNum(), serverNum);
            
            // 인증 성공 상태 기록
            session.setAttribute("authSuccess_" + authDTO.getType(), true);
            response.put("success", true);
            response.put("message", "인증에 성공하였습니다.");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // 서비스에서 던진 "인증 시간 만료" 또는 "번호 불일치" 메시지가 그대로 담깁니다.
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
    
    /**
     * 
     * 아이디 찾기
     * @author GD
     * @since 2026. 2. 24.
     * @param findDTO
     * @param session
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/find-id-complete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> findIdComplete(
										    		@RequestBody FindRequestDTO findDTO, 
										    		HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 1. 이메일 인증 성공 여부 체크 (보안)
            Boolean isVerified = (Boolean) session.getAttribute("authSuccess_ID");
            String verifiedEmail = (String) session.getAttribute("authEmail_ID");

            if (isVerified == null || !isVerified) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                                     .body(Map.of("success", false, "message", "이메일 인증이 필요합니다."));
            }
            
            if (!verifiedEmail.equals(findDTO.getEmail())) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                     .body(Map.of("success", false, "message", "인증받은 이메일 정보와 다릅니다."));
            }

            // 2. 아이디 찾기 서비스 호출
            String resultMsg = userInfoService.processFindId(findDTO);

            // 3. 사용 완료된 세션 삭제
            session.removeAttribute("authNum_ID");
            session.removeAttribute("authEmail_ID");
            session.removeAttribute("authTime_ID");
            session.removeAttribute("authSuccess_ID");

            response.put("success", true);
            response.put("result", resultMsg);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    
    /**
     * 
     * 비밀번호 재설정
     * @author GD
     * @since 2026. 2. 24.
     * @param userInfoDTO
     * @param session
     * @return
     * 수정일        수정자       수정내용
     * ----------  --------    ---------------------------
     * 2026. 2. 24.  GD       최초 생성
     */
    @PostMapping("/api/reset-pw-complete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> resetPwComplete(
									    		@RequestBody UserInfoDTO userInfoDTO, 
									    		HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 1. 이메일 인증 성공 여부 체크
            Boolean isVerified = (Boolean) session.getAttribute("authSuccess_PW");
            if (isVerified == null || !isVerified) {
                throw new Exception("이메일 인증 후 비밀번호 변경이 가능합니다.");
            }

            // 2. 서비스 호출 (검증 + 암호화 + 업데이트)
            boolean isUpdated = userInfoService.processResetPassword(userInfoDTO);

            if (isUpdated) {
                session.removeAttribute("authNum_PW");
                session.removeAttribute("authSuccess_PW");
                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
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
    
    
    /**
     * * [API] 권한 재신청 처리 (REJECTED -> PENDING)
     * @author GD
     * @since 2026. 2. 24.
     * @return 성공 여부 및 결과 메시지
     */
    @PostMapping("/api/re-apply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reApplyAuth() {
        Map<String, Object> response = new HashMap<>();
        try {
            // 1. 로그인 사용자 ID 추출
            String userId = loginUserProvider.getLoginUserId();
            
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인 세션이 만료되었습니다.");
                return ResponseEntity.status(401).body(response);
            }

            log.info("권한 재신청 요청 - User: {}", userId);

            // 2. 서비스 호출 (REJECTED 상태인 경우에만 PENDING으로 변경)
            Integer result = userInfoService.reauthorizationAppStatus(userId);

            if (result != null && result > 0) {
                response.put("success", true);
                response.put("message", "권한 재신청이 완료되었습니다. 관리자 승인을 기다려주세요.");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "재신청 대상이 아니거나 이미 처리 중입니다.");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            log.error("권한 재신청 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", "처리 중 오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
