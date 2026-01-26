package io.github.teamb.btob.dto.testjg;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class UserExcelResult {
	 private int totalCount;                       // Excel 전체 행 수
	    private int successCount;                     // 성공 처리된 행 수
	    private int failCount;                        // 실패 처리된 행 수
	    private List<Users> successList = new ArrayList<>();  // 성공 데이터
	    private List<FailItem> failList = new ArrayList<>();    // 실패 데이터

	    // Getter / Setter

	    // 실패 항목 객체
	    @Data
	    public static class FailItem {
	        private int rowNum;    // Excel 행 번호
	        private String userId; // 실패한 사용자 ID
	        private String reason; // 실패 사유

	        // Getter / Setter
	    }
}
