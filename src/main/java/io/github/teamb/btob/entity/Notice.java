package io.github.teamb.btob.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "`TB_NOTICES`")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notice_id")
    private Integer noticeId;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "view_count", nullable = false)
    private Integer viewCount = 0;

    @Column(name = "reg_dtime", nullable = false, updatable = false)
    private LocalDateTime regDtime;

    @Column(name = "reg_id", nullable = false, length = 50)
    private String regId;

    @Column(name = "upd_dtime", nullable = false)
    private LocalDateTime updDtime;

    @Column(name = "upd_id", nullable = false, length = 50)
    private String updId;

    @Column(name = "use_yn", nullable = false, columnDefinition = "CHAR(1)")
    private String useYn = "Y";

    @PrePersist
    public void prePersist() {
        this.regDtime = LocalDateTime.now();
        this.updDtime = LocalDateTime.now();
        if (this.viewCount == null) this.viewCount = 0;
        if (this.useYn == null) this.useYn = "Y";
    }

    @PreUpdate
    public void preUpdate() {
        this.updDtime = LocalDateTime.now();
    }
    
    public String getFormattedRegDate() {
        if (this.regDtime == null) return "";
        return this.regDtime.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }
    
    public String getDisplayRegId() {
        if (this.regId == null) return "";
        
        // 이메일 형식에서 @ 앞부분만 추출
        if (this.regId.contains("@")) {
            return this.regId.split("@")[0];
        }
        
        return this.regId;
    }
}