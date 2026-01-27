package io.github.teamb.btob.service.notice;

import io.github.teamb.btob.entity.Notice;
import io.github.teamb.btob.repository.NoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeRepository noticeRepository;

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
    }
}