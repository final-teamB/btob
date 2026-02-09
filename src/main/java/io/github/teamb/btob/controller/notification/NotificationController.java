package io.github.teamb.btob.controller.notification;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import io.github.teamb.btob.common.security.LoginUserProvider;
import io.github.teamb.btob.dto.notification.NotificationDTO;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;

/*
	공통 알림
	사용자가 자신의 알림을 확인하거나 읽음처리할 때 호출
 */

@RestController
@RequiredArgsConstructor
public class NotificationController {

	
	private final NotificationService notificationService;
	private final LoginUserProvider loginUserProvider;
	
	// 내 알림 목록 가져오기 (종 아이콘 클릭 시 호출)
    @GetMapping("/notificationList")
    public List<NotificationDTO> getNotifications() {
    	
    	String userId = loginUserProvider.getLoginUserId();

        if (userId == null) {
            return List.of(); // 로그인 안 돼있으면 빈 리스트
        }
        
        return notificationService.getNotificationList(userId);
    }

    // 알림 확인 시 읽음 처리
    @PutMapping("/read/{notificationId}")
    public void readNotification(@PathVariable int notificationId) {
    	
        notificationService.isReadNotification(notificationId);
    }
    
    // 
}
