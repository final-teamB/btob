package io.github.teamb.btob.dto.company;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class CompanyDTO {

    private int companySeq;       // company_seq
    private String companyCd;     // company_cd
    private String companyName;   // company_name
    private String bizNumber;     // biz_number
    private String masterName;    // master_name
    private String companyPhone;
    private String addrKor;
    private String addrEng;
    private String zipCode;
    private String customsNum;
    private LocalDateTime regDtime; // reg_dtime
    private String regId;         // reg_id
    private LocalDateTime updDtime; // upd_dtime
    private String updId;         // upd_id
    private String useYn;         // use_yn

}
