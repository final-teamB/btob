package io.github.teamb.btob.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "TB_NOTICE_FILES")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class NoticeFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notice_file_id")
    private Integer noticeFileId;

    @Column(name = "origin_file_name")
    private String originFileName;

    @Column(name = "stored_file_name")
    private String storedFileName;

    @Column(name = "reg_id")
    private String regId;

    @Column(name = "reg_dtime")
    private LocalDateTime regDtime;

    @Builder.Default
    @Column(name = "use_yn")
    private String useYn = "Y";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "notice_id")
    private Notice notice;

    @PrePersist
    public void prePersist() {
        this.regDtime = LocalDateTime.now();
        if (this.useYn == null) this.useYn = "Y";
    }
}
