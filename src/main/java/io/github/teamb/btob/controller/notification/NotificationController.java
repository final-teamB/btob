package io.github.teamb.btob.controller.notification;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import io.github.teamb.btob.dto.notification.NotificationDTO;
import io.github.teamb.btob.service.notification.NotificationService;
import io.github.teamb.btob.service.notification.SseEmitters;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class NotificationController {

	
	private final NotificationService notificationService;
	
	// 전체 접속자 명단
	private final SseEmitters sseEmitters;
	
	// 1. 알림 생성
	@GetMapping(value = "/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE) // produces = MediaType.TEXT_EVENT_STREAM_VALUE : 실시간통로
	public SseEmitter subscribe(@RequestParam String receiverId) {
		
		// SseEmitter 서버 내부에 실시간 전송용 객체 생성 (60분 동안 연결 유지)
		SseEmitter emitter = new SseEmitter(60L * 1000 * 60);
		
		// id와 emitter를 전체 접속자 명단(sseEmitters)에 추가
		// 서버가 특정사용자에게 알림을 보낼 때 누군지 찾을 수 있음
		return sseEmitters.add(receiverId, emitter);
	}
	
	// 알림 확인
	@GetMapping("/test/send-noti")
	public String testSend(@RequestParam String receiverId) {
	    // 서비스 강제 실행
		// 
	    notificationService.send(receiverId,
	    		"APPROVAL",
	    		123,
	    		"결재가 승인되었습니다!",
	    		"ADMIN");
	    return "알림 발송 완료! DB랑 SSE 통로 확인해보세요.";
	}
	
	// 2. 알림 조회
	@GetMapping("/notification")
	public List<NotificationDTO> getNotification(@RequestParam String receiverId) {
		
		return notificationService.getNotificationList(receiverId);
	}
	
	// 3. 알림 읽음
	@PutMapping("/notification/read")
	public String idReadNotification(@RequestParam int notificationId) {
		
		notificationService.isReadNotification(notificationId);
		return "읽응 처리 완료";
	}
	
	// 알림 읽음 처리 확인
	@GetMapping("/notification/read-test") // 테스트용 GetMapping
	public String readTest(@RequestParam int notificationId) {
		
	    notificationService.isReadNotification(notificationId);
	    return notificationId + "번 알림 읽음 처리 완료!";
	}
}
