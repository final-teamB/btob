package io.github.teamb.btob.dto.document;


import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class DocumentInsertDTO {

    // 문서 관리 정보
    private String docNo;          // 문서번호 (PREFIX-CORP-YYYYMMDD-SEQ)
    private String docTitle;       // 문서 제목
    private String docType;        // 문서 타입 (ESTIMATE, CONTRACT, TRANSACTION, PURCHASE_ORDER)
    private Integer orderId;       // 연결된 주문 ID
    private String ownerUserId;    // 문서 소유자(조회권한) ID
    
    // 문서 내용 정보
    private String memo;           // 메모 (상세 설명 등)
    private String docContent;     // 문서 본문 (JSON이나 HTML 등 서식 내용)
    private Integer totalAmt;      // 총 금액
    
    // 일시 정보
    // 납기 기한을 원하는 형식으로 고정 (24시간 형식)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime dueDate; 
    
    // 등록 일시 (필요 시 명시적으로 사용)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime regDtime;
    
    
    // 등록/수정 정보
    private String regId;          // 등록자 ID
    private String updId;          // 수정자 ID (초기 인서트 시 보통 regId와 동일)
    
    // 기본값 설정 (Y/N)
    private String useYn;    // 사용 여부 (기본값 Y)
 
}