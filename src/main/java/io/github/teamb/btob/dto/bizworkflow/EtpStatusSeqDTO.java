package io.github.teamb.btob.dto.bizworkflow;

import lombok.Data;


/**
 * 
 * 견적/주문/구매/결제 현재상태코드의 다음단계 상태코드 조회 (승인) DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class EtpStatusSeqDTO {
	
	private String systemId;		// 시스템ID
	private String etpSttsCd;		// 상태코드
	private String etpSttsNm;		// 상태코드명
	private Integer seq;			// 상태코드순서
	
	private String sttsTypeCd;		// 상태코드타입 ( 일반 / 긴급 ) 현재는 사용안함
	
	// 현재상태코드
	private String currentEtpStatus;
}
