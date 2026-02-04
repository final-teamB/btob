package io.github.teamb.btob.dto.notification;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class NotificationDTO {
	private int notificationId;
	private String receiverId;
	private String senderId;
	private String notificationType; // ENUM: 'APPROVAL','ORDER','DELIVERY','PAYMENT'
	private int targetId;
	private String message;
	private String isRead;
	
	private LocalDateTime regDtime;
	private String regId;
	private LocalDateTime updDtime;
	private String updId;
	private String useYn;
}
