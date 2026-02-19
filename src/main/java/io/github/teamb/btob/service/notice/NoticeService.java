package io.github.teamb.btob.service.notice;

import io.github.teamb.btob.entity.Notice;
import io.github.teamb.btob.repository.NoticeRepository;
import io.github.teamb.btob.repository.UserRepository;
import io.github.teamb.btob.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NotificationService notificationService;
    private final NoticeRepository noticeRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<Notice> getNoticeList(String keyword) {
        if (keyword != null && !keyword.isEmpty()) {
            return noticeRepository.findByTitleContainingAndUseYnOrderByNoticeIdDesc(keyword, "Y");
        }
        return noticeRepository.findByUseYnOrderByNoticeIdDesc("Y");
    }

    @Transactional
    public Notice getNoticeDetail(Integer id) {
        Notice notice = noticeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("공지사항을 찾을 수 없습니다."));
        
        // 조회수 증가
        notice.setViewCount(notice.getViewCount() + 1);
        return notice;
    }

    @Transactional
    public void saveNotice(Notice notice) {
        noticeRepository.save(notice);
        
        // 알림
        List<String> userIds = userRepository.findAllUserIds();
        
        if(userIds != null && !userIds.isEmpty()) {
        	String msg ="새로운 공지가 등록되었습니다 [" + notice.getTitle() +"]";
        	
        	for(String userId : userIds) {
        		notificationService.send(userId, "NOTICE", notice.getNoticeId(), msg, notice.getRegId());
        	}
        }
    }
    
    @Transactional
    public void updateNotice(Notice notice) {
        Notice existing = noticeRepository.findById(notice.getNoticeId()).orElseThrow();
        // 변경된 내용 반영
        existing.setTitle(notice.getTitle());
        existing.setContent(notice.getContent());
        existing.setUpdId(notice.getUpdId());
        existing.setUpdDtime(LocalDateTime.now());
        // JPA 더티 체킹에 의해 자동 업데이트
    }

    @Transactional
    public void deleteNotice(Integer id) {
        Notice notice = noticeRepository.findById(id).orElseThrow();
        notice.setUseYn("N"); // 실제 삭제 대신 상태값만 변경 (Soft Delete)
    }
}