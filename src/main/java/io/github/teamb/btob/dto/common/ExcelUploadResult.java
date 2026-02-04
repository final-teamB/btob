package io.github.teamb.btob.dto.common;

import java.util.ArrayList;
import java.util.List;
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
public class ExcelUploadResult<T> {

    private int totalCount;                    // Excel 전체 행 수
    private int successCount;                  // 성공 처리된 행 수
    private int failCount;                     // 실패 처리된 행 수
    private List<T> successList = new ArrayList<>();  // 성공 데이터
    private List<FailItem> failList = new ArrayList<>(); // 실패 데이터

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @ToString
    public static class FailItem {
        private int rowNum;    // Excel 행 번호
        private String userId; // 실패한 사용자 ID
        private String reason; // 실패 사유
    }
}
