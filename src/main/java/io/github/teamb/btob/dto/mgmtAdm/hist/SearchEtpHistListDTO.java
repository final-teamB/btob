package io.github.teamb.btob.dto.mgmtAdm.hist;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class SearchEtpHistListDTO {
	
	private Integer etpId;				// 식별자( 견적, 주문, 구매, 결제 )
	private Integer regId;				// 요청자
	private Integer requestUserNm;		// 요청자 성명
	private Integer apprUserId;			// 승인자
	private Integer apprUserNm;			// 승인자 성명
	private String etpSttsCd;			// 상태코드
	private String etpSttsNm;			// 상태코드명
	private String rejtRsn;				// 반려사유
	private LocalDateTime regDtime;		// 요청일자
	private LocalDateTime apprDtime;	// 승인일자
	
	private Integer rownm;				// 순번
}
