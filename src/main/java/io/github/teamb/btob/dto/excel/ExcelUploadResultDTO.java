package io.github.teamb.btob.dto.excel;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 
 * 엑셀 성공 실패 로직 분류 처리
 * @author GD
 * @since 2026. 2. 3.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 3.  GD       최초 생성
 */
@Data
@Builder
@NoArgsConstructor // 1. 전체 클래스용 기본 생성자 (Jackson용)
@AllArgsConstructor // 2. Builder 사용 시 필요한 전체 생성자
public class ExcelUploadResultDTO<T> {
    private Integer totalCount;      // 전체 행 수
    private Integer successCount;    // 성공 건수
    private Integer failCount;       // 실패 건수
    private List<T> successList; 	// 성공한 데이터 리스트 (DB 전송용)
    private List<ExcelFailDetail> failList; // 실패한 데이터 리스트 (사유 포함)

    @Data
    @NoArgsConstructor  // [핵심!] JSON 변환을 위해 반드시 필요합니다.
    @AllArgsConstructor
    public static class ExcelFailDetail {
    	
        private Integer rowNum;      // 엑셀 행 번호
        private String errorMsg; // 에러 사유
        private Map<String, Object> rowData; // [추가] 사용자가 입력했던 데이터 전체
    }
}
