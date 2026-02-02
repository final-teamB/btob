package io.github.teamb.btob.service.faq;

import io.github.teamb.btob.entity.Faq;
import io.github.teamb.btob.repository.faq.FaqRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FaqService {

    private final FaqRepository faqRepository;

    @Transactional(readOnly = true)
    public List<Faq> getActiveFaqList() {
        return faqRepository.findByUseYnOrderByRegDtimeDesc("Y");
    }

    @Transactional
    public void saveFaq(Faq faq) {
        if (faq.getFaqId() != null) {
            faq.setUpdDtime(LocalDateTime.now());
        }
        faqRepository.save(faq);
    }

    @Transactional
    public void deleteFaq(Integer id) {
        // 실제 삭제 대신 상태값만 변경 (Soft Delete)
        Faq faq = faqRepository.findById(id).orElseThrow();
        faq.setUseYn("N");
    }
}