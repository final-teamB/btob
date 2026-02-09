package io.github.teamb.btob.dto.mgmtAdm.est;

import java.util.List;

import lombok.Getter;

/**
 * 
 * 프론트단에서 가져온 통합 DTO 분할 처리
 * @author GD
 * @since 2026. 1. 30.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 1. 30.  GD       최초 생성
 */
@Getter
public class EstRequestDTO {

	// 1. TB_EST_DOC 정보
    private InsertEstDocDTO doc;
    // 2. TB_EST_CART 정보 (필요 시)
    private InsertEstCartDTO cart;
    // 3. TB_EST_CART_ITEM 리스트 (N개)
    private List<InsertEstCartItemDTO> items;
    // 4. TB_EST_MST
    private InsertEstMstDTO estMst;
}
