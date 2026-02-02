package io.github.teamb.btob.dto.common;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PagingResponseDTO<T> {
	
	private List<T> list;      // 조회된 결과 목록
    private Integer totalCnt;  // 전체 건수
}
