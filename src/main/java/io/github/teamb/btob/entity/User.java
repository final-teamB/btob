package io.github.teamb.btob.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "`TB_USERS`")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_no")
    private Integer userNo;

    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(name = "user_name", nullable = false, length = 50)
    private String userName;

    @Column(nullable = false, length = 20)
    private String phone;

    @Column(nullable = false, length = 100)
    private String email;
    
    @Column(length = 50)
    private String position; // 직위

    @Column(length = 255)
    private String address;  // 주소

    @Column(name = "business_number", length = 20)
    private String businessNumber; // 사업자번호

    @Column(name = "is_representative", length = 1)
    private String isRepresentative; // 대표자 여부 (Y/N)

    @Column(name = "company_cd")
    private String companyCd;

    @Transient
    private String docId;

    @Enumerated(EnumType.STRING)
    @Column(name = "user_type")
    private UserType userType = UserType.USER; 

    @Enumerated(EnumType.STRING)
    @Column(name = "app_status")
    private AppStatus appStatus = AppStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "acc_status")
    private AccStatus accStatus = AccStatus.ACTIVE;

    @Column(name = "reg_dtime", updatable = false)
    private LocalDateTime regDtime;

    @Column(name = "reg_id")
    private String regId;

    @Column(name = "upd_dtime")
    private LocalDateTime updDtime;

    @Column(name = "upd_id")
    private String updId;

    @Column(name = "use_yn", columnDefinition = "CHAR(1)")
    private String useYn = "Y";

    @PrePersist
    public void prePersist() {
        this.regDtime = LocalDateTime.now();
        this.updDtime = LocalDateTime.now();
        if (this.useYn == null) this.useYn = "Y";
        if (this.userType == null) this.userType = UserType.USER;
        if (this.appStatus == null) this.appStatus = AppStatus.PENDING;
        if (this.accStatus == null) this.accStatus = AccStatus.ACTIVE;
    }

    @PreUpdate
    public void preUpdate() {
        this.updDtime = LocalDateTime.now();
    }
}
