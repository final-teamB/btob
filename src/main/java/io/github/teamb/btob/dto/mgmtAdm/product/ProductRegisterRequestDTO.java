package io.github.teamb.btob.dto.mgmtAdm.product;

import java.util.List;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import lombok.Data;

/**
 * 
 * 컨트롤러단에서 사용할 상품등록 Request DTO
 * @author GD
 * @since 2026. 2. 2.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 2.  GD       최초 생성
 */
@Data
public class ProductRegisterRequestDTO {
	
	// 1. 상품 기본 정보 (TB_PRODUCT 관련)
    private InsertProductDTO productBase;
    
    // 2. 상품 상세 정보 (TB_PRODUCT_DETAIL 관련)
    private InsertDetailInfoProductDTO productDetail;
    
    // 3. 상품 첨부 이미지 (기존에 쓰던 방식 유지용)
    private List<AtchFileDto> productImg;
    
    /**
     * 추가: 임시 저장 폴더(D:\temp\img)에 저장된 파일명
     * JS의 previewImage 성공 시 반환받은 파일명을 여기에 담아 보냅니다.
     */
    private List<String> mainTempNames;   // 메인 이미지 임시파일명 리스트
    private List<String> subTempNames;    // 서브 이미지 임시파일명 리스트
}
