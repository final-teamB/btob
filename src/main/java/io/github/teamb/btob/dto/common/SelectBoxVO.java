package io.github.teamb.btob.dto.common;

import lombok.Data;

/**
 * 
 * 셀렉박스 동적쿼리 시 컬럼명 고정
 * @author GD
 * @since 2026. 2. 6.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 6.  GD       최초 생성
 */
@Data
public class SelectBoxVO {
    private String value; // DB의 PK나 코드값
    private String text;  // DB의 컬럼명칭
}