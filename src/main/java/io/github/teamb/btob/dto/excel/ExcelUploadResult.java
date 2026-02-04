package io.github.teamb.btob.dto.excel;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

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
public class ExcelUploadResult<T> {
    private Integer totalCount;      // 전체 행 수
    private Integer successCount;    // 성공 건수
    private Integer failCount;       // 실패 건수
    private List<T> successList; 	// 성공한 데이터 리스트 (DB 전송용)
    private List<ExcelFailDetail> failList; // 실패한 데이터 리스트 (사유 포함)

    @Data
    @AllArgsConstructor
    public static class ExcelFailDetail {
    	
        private Integer rowNum;      // 엑셀 행 번호
        private String errorMsg; // 에러 사유
    }
}
