package io.github.teamb.btob.dto.attachfile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 
 * 첨부파일 DTO
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Getter
@Setter
@NoArgsConstructor
public class AtchFileDto {
    private Integer fileId;
    private String systemId;      // NOTICE, USER_BATCH등 SYSTEM_ID 값
    private Integer refId;          // 공지사항 ID 등 식별자가 들어옴
    private String orgFileNm;    // 원본 파일명
    private String strFileNm;    // 서버 저장용 UUID 명칭
    private String filePath;     // 실제 저장 경로
    private String fileExt;      // 확장자
    private Long fileSize;       // 파일 크기
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDtime;        // 등록 일시
    private Integer regId;		// 생성자
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updDtime;		// 수정시간
    private Integer updId;				// 수정자
    private String useYn;
    // Getter, Setter 생략
    
    
    // PDF 다운 시 날짜형식때문에 추가함
    // JSP는 'get'을 떼고 'regDtimeDisplay'라는 이름으로 이 값을 부를 수 있습니다.
    public String getRegDtimeDisplay() {
        if (regDtime == null) return "";
        return regDtime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
    
    // 이미지 상세정보 관련 url 처리
    private String FileUrl;
}
