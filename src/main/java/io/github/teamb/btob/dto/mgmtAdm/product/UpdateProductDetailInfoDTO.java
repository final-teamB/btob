package io.github.teamb.btob.dto.mgmtAdm.product;

import java.time.LocalDateTime;

import lombok.Data;

/**
 * 
 * 상품 상세정보 수정 DTO
 * @author GD
 * @since 2026. 1. 29.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 29.  GD       최초 생성
 */
@Data
public class UpdateProductDetailInfoDTO {
	
	private Integer fuelId;			// 식별코드
    private Integer apiGrv;          // API 비중
    private Integer sulfurPCnt;      // 유황 함량
    private Integer flashPnt;        // 인화점
    private Integer viscosity;       // 점도
    private Integer density15c;      // 15도 밀도
    private String fuelMemo;		// 상세내용
    private String regId;			// 등록자 ID
    private String useYn;			// 사용여부 YN
    private LocalDateTime updDtime; // 수정일자
    private String updId;           // 수정자 ID
}
