package io.github.teamb.btob.jprtest.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;

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
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDtime;        // 등록 일시
    private int regId;		// 생성자
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updDtime;		// 수정시간
    private int updId;				// 수정자
    private String useYn;
    // Getter, Setter 생략
    
    
    // PDF 다운 시 날짜형식때문에 추가함
    // JSP는 'get'을 떼고 'regDtimeDisplay'라는 이름으로 이 값을 부를 수 있습니다.
    public String getRegDtimeDisplay() {
        if (regDtime == null) return "";
        return regDtime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}
