package io.github.teamb.btob.dto.adminDelivery;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class DeliveryDTO {
	
	private int deliveryId;
	private int orderId;
	private String orderNo;
	private DeliveryStatus deliveryStatus;
	private String trackingNo;
	private String carrierName;
	
	private String shipFromAddr;
	private String shipToAddr;
	
	private LocalDateTime regDtime;
	private String regId;
	private LocalDateTime updDtime;
	private String updId;
	private String useYn;
	
	private String orderStatus;
	
	private String companyName;    // 회사명 (company_name)
    private String addrKor;        // 회사 주소 (addr_kor)
    private String zipCode;        // 우편번호 (zip_code)
	
	private String searchStartDate;    // 검색 시작일
	private String searchEndDate;      // 검색 종료일
	private String searchType;   // 검색 조건 (주문번호, 송장번호 등)
	private String searchKeyword;      // 검색어
	
	// 배송상태 자동 번역
	public String getStatusName() {
		return(this.deliveryStatus != null) ? this.deliveryStatus.getDescription() : "";
	}
}	
