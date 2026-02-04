package io.github.teamb.btob.repository;

import io.github.teamb.btob.entity.Notice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface NoticeRepository extends JpaRepository<Notice, Integer> {
    // 제목 검색 + 사용 여부 'Y'인 것만 최신순 조회
    List<Notice> findByTitleContainingAndUseYnOrderByNoticeIdDesc(String title, String useYn);
    
    // 전체 목록 최신순 조회
    List<Notice> findByUseYnOrderByNoticeIdDesc(String useYn);
}