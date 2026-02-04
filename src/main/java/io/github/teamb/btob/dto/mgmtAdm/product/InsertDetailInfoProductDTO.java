package io.github.teamb.btob.dto.mgmtAdm.product;

import lombok.Builder;
import lombok.Data;

/**
 * 
 * 상품 상세정보 등록 DTO
 * 관련 테이블 == TB_OIL_MST_DETAIL
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
@Builder
public class InsertDetailInfoProductDTO {

	private Integer fuelId;			// 상품 식별번호
    private Integer apiGrv;          // API 비중
    private Integer sulfurPCnt;      // 유황 함량
    private Integer flashPnt;        // 인화점
    private Integer viscosity;       // 점도
    private Integer density15c;      // 15도 밀도
    private Integer regId;			// 등록자 ID
    private String useYn;			// 사용여부 YN
}
