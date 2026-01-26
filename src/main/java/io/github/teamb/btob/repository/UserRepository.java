package io.github.teamb.btob.repository;

import io.github.teamb.btob.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    // 이메일을 ID로 사용하기 위한 쿼리 메서드
    Optional<User> findByEmail(String email);
}
