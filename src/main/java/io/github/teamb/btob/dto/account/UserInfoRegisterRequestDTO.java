package io.github.teamb.btob.dto.account;

import lombok.Data;

/**
 * 
 * 컨트롤러단에서 사용할 사용자 등록 Request DTO
 * @author GD
 * @since 2026. 2. 20.
 * * 수정일        수정자       수정내용
 * ----------  --------    ---------------------------
 * 2026. 2. 20.  GD       최초 생성
 */
@Data
public class UserInfoRegisterRequestDTO {
	
	// 사용자테이블 인서트
	private UserInfoDTO insertUserInfo;
	
	// 회사테이블 인서트
	private CompanyInfoDTO insertCompanyInfo;
}
