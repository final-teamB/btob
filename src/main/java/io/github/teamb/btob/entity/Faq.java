package io.github.teamb.btob.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "TB_FAQ")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Faq {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "faq_id")
    private Integer faqId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private FaqCategory category;

    @Column(length = 255)
    private String question;

    @Column(columnDefinition = "LONGTEXT")
    private String answer;

    @Column(name = "reg_dtime", updatable = false)
    private LocalDateTime regDtime;

    @Column(name = "reg_id", length = 50)
    private String regId;

    @Column(name = "upd_dtime")
    private LocalDateTime updDtime;

    @Column(name = "upd_id", length = 50)
    private String updId;

    @Column(name = "use_yn", length = 1)
    private String useYn = "Y";

    @PrePersist
    public void prePersist() {
        this.regDtime = LocalDateTime.now();
        this.updDtime = LocalDateTime.now();
        if (this.useYn == null) this.useYn = "Y";
    }

    @PreUpdate
    public void preUpdate() {
        this.updDtime = LocalDateTime.now();
    }

    public enum FaqCategory {
        DELIVERY("배송"), PAYMENT("결제"), PRODUCT("상품"), ETC("기타");
        private final String label;
        FaqCategory(String label) { this.label = label; }
        public String getLabel() { return label; }
    }
}