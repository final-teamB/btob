package io.github.teamb.btob.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import io.github.teamb.btob.dto.account.LoginValidateDTO;
import lombok.RequiredArgsConstructor;

//record는 자바 14에서 나온 것으로 데이터만 담는 불변 클래스
//UserDetails 는 security에서 제공하므로 따로 인터페이스를 생성할 필요 없다
//UserDetails 인터페이스를 직접 구현한 커스텀 사용자 정보 클래스
//인증에 필요한 사용자 정보를 스프링 시큐리티에 맞게 포장하는 역할
//한마디로 로그인한 사용자의 계정 상태 + 권한 정보 등을 검증 확인
@RequiredArgsConstructor
public class CustomUserDetails implements UserDetails {

	// 임시 2로 함
	private static final long serialVersionUID = 1L;
	private final LoginValidateDTO loginValidateDTO;

		 /**
		  * 
		  * 사용자 권한 검증
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public Collection<? extends GrantedAuthority> getAuthorities() {
		
			     // ROLE 테이블 붙이는 곳
			     List<GrantedAuthority> authorities = new ArrayList<>();
			
			     // 1. ROLE 권한 (접두사 ROLE_ 필수)
			     if (loginValidateDTO.getUserType() != null) {
			
			         authorities.add(
			                 new SimpleGrantedAuthority("ROLE_" + loginValidateDTO.getUserType().toUpperCase())
			         );
			     }
			     
			     // 2. ROLE 권한 (접두사 ROLE_ 필수) -- 버튼 권한
			     if (loginValidateDTO.getUserType() != null) {
			
			         authorities.add(
			                 new SimpleGrantedAuthority("ROLE_" + loginValidateDTO.getAppStatus().toUpperCase())
			         );
			     }
			
			     // return List.of(); 권한 스킵
			     // 일반적인 권한 + 세부권한 생기는 경우 때문에 리스트로
			     return authorities;
		 }
		 
		 /**
		  * 
		  * 사용자 타입 검증
		  * @author GD
		  * @since 2026. 2. 25.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 25.  GD       최초 생성
		  */
		 public String getUserType() {
		        return loginValidateDTO.getUserType();
		    }
		 
		
		 /**
		  * 
		  * 사용자 비밀번호 검증
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public String getPassword() {
		
		     return loginValidateDTO.getPassword();
		 }
		
		
		 /**
		  * 
		  * 사용자 ID 검증
		  * 메서드명은 username이지만 userId로 검증합니다.
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public String getUsername() {
		
		     return loginValidateDTO.getUserId();
		 }
		

		 /**
		  * 
		  * 사용자 계정 상태 검증 부분 
		  * 해당 조건들 TRUE 시 로그인 가능
		  * ===================
		  * ACTIVE (사용가능)
		  * INACTIVE(사용불가)
		  * LOCKED(계정잠금)
		  * SLEEP(휴먼계정)
		  * DELETED(폐지)
		  * BANNED(벤처리)
		  * EXPIRED(만료)
		  * ====================
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public boolean isEnabled() {
		
		     return ("ACTIVE".equals(loginValidateDTO.getAccStatus()))
		    		 && !("BANNED".equals(loginValidateDTO.getAccStatus()))
		    		 && !("DELETED".equals(loginValidateDTO.getAccStatus()))
		    		 && !("INACTIVE".equals(loginValidateDTO.getAccStatus()));
		 }
		
		 /**
		  * 
		  * 계정 만료 여부 검증 ( 계정 사용 기간 )
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public boolean isAccountNonExpired() {
			 
			 
		     if (loginValidateDTO.getUserExpiredDate() == null) {
		
		         return true;
		     }
			 
			 // 일단 스킵
		     return UserDetails.super.isAccountNonExpired();
		     //return LocalDateTime.now().isBefore(loginValidateDTO.getUserExpiredDate());
		 }
		
		 /**
		  * 
		  * 계정 잠김 여부 검증
		  * appStatus		// PENDING (사용대기중) , APPROVED(승인), REJECTED(반려)
		  * accStatus		// 사용자 계정 상태 ACTIVE (사용가능), INACTIVE(사용불가), LOCKED(계정잠금), SLEEP(휴먼계정), DELETED(폐지), BANNED(벤처리), EXPIRED(만료)
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public boolean isAccountNonLocked() {
		
		     // 1. 계정 승인 상태 체크
			 // 이건 임시주석 로그인 때 체크 안함.
			 /*
		     boolean isNotPending = !("PENDING".equals(loginValidateDTO.getAppStatus()) ||
		    		 					"REJECTED".equals(loginValidateDTO.getAppStatus())
		    		 				  ); 
			*/
			 
		     // 2. 행정적 제한 상태 체크
		     boolean isNotRestricted = !("LOCKED".equals(loginValidateDTO.getAccStatus()));
		
		     // 3. 보안 정책 체크 (실패 횟수) 5회미만
		     boolean isFailCountValid = loginValidateDTO.getUserLoginFailCnt() < 5;
		
		     // 최종 결과: 두 조건 모두 만족해야 로그인 가능
		     // return isNotPending && isNotRestricted && isFailCountValid;
		     return isNotRestricted && isFailCountValid;
		 }
		
		 /**
		  * 
		  * 비밀번호 만료 여부 검증 ( 비밀번호 사용 기간 )
		  * @author GD
		  * @since 2026. 2. 20.
		  * @return
		  * 수정일        수정자       수정내용
		  * ----------  --------    ---------------------------
		  * 2026. 2. 20.  GD       최초 생성
		  */
		 @Override
		 public boolean isCredentialsNonExpired() {
		
			 // 일단 스킵처리함
		     if (loginValidateDTO.getPwExpiredDate() == null) return true;
		
		     return UserDetails.super.isCredentialsNonExpired();
		     //return LocalDateTime.now().isBefore(loginValidateDTO.getPwExpiredDate());
		 }
}