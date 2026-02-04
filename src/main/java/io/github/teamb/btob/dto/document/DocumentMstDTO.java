package io.github.teamb.btob.dto.document;

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
public class DocumentMstDTO {

    private int docId;              // doc_id
    private String docNo;           // doc_no
    private String docType;         // doc_type
    private int orderId;            // order_id
    private int ownerUserId;        // owner_user_id
    private LocalDateTime regDtime; // reg_dtime
    private String memo;           // memo
    private String regId;           // reg_id
    private LocalDateTime updDtime; // upd_dtime
    private String updId;           // upd_id
    private String useYn;           // use_yn (Y/N)

}
