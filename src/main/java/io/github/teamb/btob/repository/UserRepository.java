package io.github.teamb.btob.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import io.github.teamb.btob.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {
    // 이메일을 ID로 사용하기 위한 쿼리 메서드
    Optional<User> findByEmail(String email);
    
    // 전체 알림 발송을 위해 활성화된 모든 사용자 ID 조회
    @Query("SELECT u.userId FROM User u WHERE u.useYn = 'Y'")
    List<String> findAllUserIds();
}
