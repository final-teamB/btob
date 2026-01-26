package io.github.teamb.btob.mapper.notification;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import io.github.teamb.btob.dto.notification.NotificationDTO;

@Mapper
public interface NotificationMapper {
	
	// 알림 생성
	int insertNotification(NotificationDTO dto);
	
	// 알림 목록 조회
	List<NotificationDTO> selectNotification(@Param("receiverId") String receiverId);
	
	// 알림 읽음 처리
	int updateReadStatus(@Param("notificationId") int notificationId);
}
