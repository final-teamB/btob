package io.github.teamb.btob.jprtest.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class AtchFileDto {
    private int fileId;
    private String refTypeCd;      // NOTICE, USER_BATCH 등
    private int refId;          // 공지사항 ID 등
    private String orgFileNm;    // 원본 파일명
    private String strFileNm;    // 서버 저장용 UUID 명칭
    private String filePath;     // 실제 저장 경로
    private String fileExt;      // 확장자
    private Long fileSize;       // 파일 크기
    private LocalDateTime regDtime;        // 등록 일시
    private int regId;		// 생성자
    private LocalDateTime upd_dtime;		// 수정시간
    private int upd_id;				// 수정자
    private String useYn;
    // Getter, Setter 생략
    
    
    // JSP는 'get'을 떼고 'regDtimeDisplay'라는 이름으로 이 값을 부를 수 있습니다.
    public String getRegDtimeDisplay() {
        if (regDtime == null) return "";
        return regDtime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}
