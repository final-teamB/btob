package io.github.teamb.btob.dto.est;

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
public class EstDocInsertDTO {

    private Integer estDocId;            // 고유식별자
    private String estNo;                // 견적번호
    private String companyName;          // 회사명
    private String companyPhone;         // 회사연락처
    private Integer requestUserId;       // 요청자ID
    private Integer apprUserId;          // 승인자ID
    private String ctrtNm;               // 계약명
    private Integer orderId;           // 견적서 물품 리스트 FK
    private String estStatus;
    private Integer baseTotalAmount;     // 기존 총액
    private Integer targetTotalAmount;   // 예상 총액
    private String estdtMemo;            // 요청 상세 내용
    private LocalDateTime regDtime;       // 생성시간
    private String regId;               // 생성자 = 요청자
    private LocalDateTime updDtime;       // 수정시간
    private Integer updId;               // 수정자
    private String useYn;                // 사용여부 Y/N
}
