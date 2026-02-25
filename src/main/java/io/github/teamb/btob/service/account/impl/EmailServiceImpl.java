package io.github.teamb.btob.service.account.impl;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import io.github.teamb.btob.service.account.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {
	
	private final JavaMailSender mailSender;
	
	/**
	 * 
	 * 이메일 전송 전담
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param email
	 * @param authNum
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public String sendAuthMail(String email, String type) {
		
		try {
	        // 1. 6자리 난수 생성
	        String authNum = String.valueOf((int)(Math.random() * 899999) + 100000);
	        
	     // 2. MimeMessage 생성
	        MimeMessage mimeMessage = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

	        // 3. 발신자 설정 (이름 <가짜메일주소>)
	        // 실제 발송은 application.properties에 설정된 계정으로 나가지만, 
	        // 받는 사람 화면에는 아래 설정한 이름과 주소가 뜹니다.
	        helper.setFrom("TradeHuB <GDAteamAdmin@gmail.com>"); 
	        
	        helper.setTo(email);
	        helper.setSubject("[B2B 시스템] " + (type.equals("ID") ? "아이디 찾기" : "비밀번호 재설정") + " 인증번호");
	        
	        // HTML 형식으로 보내면 더 깔끔합니다.
	        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>"
	                           + "<h2>안녕하세요. TradeHuB입니다.</h2>"
	                           + "<p>본인 확인을 위한 인증번호는 다음과 같습니다.</p>"
	                           + "<h1 style='color: #2563eb;'>" + authNum + "</h1>"
	                           + "<p>인증번호 입력 칸에 위 번호를 입력해 주세요.</p>"
	                           + "</div>";
	        
	        helper.setText(htmlContent, true); // true를 주면 HTML로 렌더링됩니다.

	        // 4. 발송
	        mailSender.send(mimeMessage);
	        
	        return authNum;

		} catch (MessagingException e) {
	        // 메일 구조 생성 실패 시 (주소 형식 오류 등)
	        log.error("메일 구성 실패: ", e);
	        throw new RuntimeException("메일 형식이 올바르지 않습니다.");
	    } catch (Exception e) {
	        // 그 외 네트워크 오류 등 모든 예외 처리
	        log.error("메일 발송 중 알 수 없는 에러: ", e);
	        throw new RuntimeException("메일 발송 중 오류가 발생했습니다.");
	    }
	}

	
	/**
	 * 
	 * 인증번호 검증 로직
	 * @author GD
	 * @since 2026. 2. 24.
	 * @param userInputNum
	 * @param serverAuthNum
	 * @return
	 * 수정일        수정자       수정내용
	 * ----------  --------    ---------------------------
	 * 2026. 2. 24.  GD       최초 생성
	 */
	@Override
	public boolean verifyAuthNum(String userInputNum, String serverAuthNum) throws Exception {

		// 1. 세션에 저장된 번호가 없는 경우 (시간 만료)
	    if (serverAuthNum == null) {
	        throw new Exception("인증 시간이 만료되었습니다. 인증번호를 다시 요청해 주세요.");
	    }
	    
	    // 2. 번호가 일치하지 않는 경우
	    if (!serverAuthNum.equals(userInputNum)) {
	        throw new Exception("인증번호가 일치하지 않습니다. 다시 확인해 주세요.");
	    }
		
        return true;
	}

}
