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
public class DocumentListDTO {
	
	private int docId;              // doc_id
    private String docNo;			// doc_no
    private String docType;			// doc_type
    private int ownerUserId;        // owner_user_id내부 로직용
    private String userName;        // ownerUserName 화면 표시용
    private String memo;  			// memo
    private LocalDateTime regDtime; // reg_dtime
}
