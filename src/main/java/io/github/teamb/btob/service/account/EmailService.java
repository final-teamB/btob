package io.github.teamb.btob.service.account;

public interface EmailService {
	
	// 메일 발송 전담
	String sendAuthMail(String email, String type);
	
	// 검증 로직
	boolean verifyAuthNum(String userInputNum, String serverAuthNum) throws Exception; 
}
