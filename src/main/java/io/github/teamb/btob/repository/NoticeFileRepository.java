package io.github.teamb.btob.repository;

import io.github.teamb.btob.entity.NoticeFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NoticeFileRepository extends JpaRepository<NoticeFile, Integer> {
    // 기본적인 저장(save), 조회(findById), 삭제(delete)는 JpaRepository가 제공
}
