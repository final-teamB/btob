package io.github.teamb.btob.service.notification;

import java.util.List;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.notification.NotificationDTO;
import io.github.teamb.btob.mapper.notification.NotificationMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationService {

	private final NotificationMapper notificationMapper;
	
	public void send(String receiverId, String notificationType, int targetId, String message, String senderId) { 
		NotificationDTO dto = new NotificationDTO();
		dto.setReceiverId(receiverId);
		dto.setNotificationType(notificationType);
		dto.setTargetId(targetId);
		dto.setMessage(message);
		
		// 보낸사람이 없으면 admin
		String finalSender = (senderId != null && !senderId.isEmpty()) ? senderId : "admin";
		
		dto.setSenderId(finalSender);
		dto.setRegId(finalSender);
		dto.setUpdId(finalSender);
        
		// 알림 기록 DB에 저장
        notificationMapper.insertNotification(dto);
	}
	
	// 알림 목록
	public List<NotificationDTO> getNotificationList(String receiverId) {
		
		return notificationMapper.selectNotification(receiverId);
	}
	
	// 알림 읽음
	public void isReadNotification(int notificationId) {
		
		notificationMapper.updateReadStatus(notificationId);
	}
}
