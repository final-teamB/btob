package io.github.teamb.btob.dto.adminDelivery;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class DeliveryHistoryDTO {
	
	private int hisId;
    private int deliveryId;
    private DeliveryStatus prevDeliveryStatus; // 변경 전 상태
    private DeliveryStatus deliveryStatus;     // 변경 후 상태
    private String memo;
    private LocalDateTime regDtime;
    private String regId;
    private String useYn;
}
