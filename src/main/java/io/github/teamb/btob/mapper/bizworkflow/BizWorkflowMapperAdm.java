package io.github.teamb.btob.mapper.bizworkflow;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.bizworkflow.BizChkParamsDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpDynamicParamsDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpHistInsertDTO;
import io.github.teamb.btob.dto.bizworkflow.EtpStatusUpdateDTO;


@Mapper
public interface BizWorkflowMapperAdm {

	// 1. 현재 상태코드 추출
	String selectCurrentEtpSttsCd(BizChkParamsDTO bizChkParamsDTO);

	// 2. 사용자 권한 확인 체크
	BizChkParamsDTO selectUserTypeChk(String userId);

	// 3. 현재 상태코드의 다음단계 상태코드 조회
	BizChkParamsDTO selectNextStatus(String currentEtpStatus);

	// 4.  현재상태코드의 반려 상태코드 조회
	String selectRejtStatus(String systemId);

	// 5. 동적쿼리 사용 시 적용할 테이블, 상태 컬럼, 식별자컬럼 확인
	EtpDynamicParamsDTO selectTargetParams(String systemId);

	// 6. 동적쿼리에 사용 시 식별번호 값 확인
	BizChkParamsDTO selectRefIds(BizChkParamsDTO bizChkParamsDTO);

	// 7. 견적/주문/구매/결제 상태코드 업데이트
	Integer updateEtpStatus(EtpStatusUpdateDTO etpStatusUpdateDTO);

	// 8. 고정으로 오더 테이블 상태코드는 계속 변경된다.
	Integer fixUpdateOrderStatus(EtpStatusUpdateDTO etpStatusUpdateDTO);

	// 9. 견적/주문/구매/결제 이력 추가
	Integer insertEtpHist(EtpHistInsertDTO etpHistInsertDTO);


	// 재고량 관련
	// 반품 제품명 및 수량 확인
	List<BizChkParamsDTO> selectReturnProductIdAndQty(Integer orderId);

}