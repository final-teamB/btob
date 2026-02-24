package io.github.teamb.btob.dto.account;

import lombok.Data;

/**
 * 
 * 컨트롤러단에서 사용하는 사용자 정보 업데이트 DTO
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Data
public class UserInfoModifyRequestDTO {
	
		// 사용자테이블 업데이트
		private UserInfoDTO updateUserInfo;
		
		// 회사테이블 업데이트
		private CompanyInfoDTO updateCompanyInfo;
}
