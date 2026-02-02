package io.github.teamb.btob.repository.faq;

import io.github.teamb.btob.entity.Faq;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FaqRepository extends JpaRepository<Faq, Integer> {
    // 노출 여부가 'Y'인 FAQ만 카테고리별/최신순 등으로 조회 가능
    List<Faq> findByUseYnOrderByRegDtimeDesc(String useYn);
}