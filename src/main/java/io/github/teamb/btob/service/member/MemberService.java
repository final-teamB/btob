package io.github.teamb.btob.service.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.entity.User;
import io.github.teamb.btob.entity.UserType;
import io.github.teamb.btob.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MemberService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public MemberDto getMyInfo(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다."));
        
        MemberDto dto = new MemberDto();
        dto.setUserId(user.getUserId());
        dto.setUserName(user.getUserName());
        dto.setEmail(user.getEmail());
        dto.setPhone(user.getPhone());
        dto.setPosition(user.getPosition());
        
        // 공통 주소 매핑 [cite: 16]
        dto.setPostcode(user.getPostcode());
        dto.setAddress(user.getAddress());
        dto.setDetailAddress(user.getDetailAddress());
        
        dto.setUserType(user.getUserType().name());
        dto.setBusinessNumber(user.getBusinessNumber());
        dto.setIsRepresentative(user.getIsRepresentative());

        if (user.getUserType() == UserType.MASTER) {
            dto.setCompanyName(user.getCompanyCd()); 
        } else {
            dto.setCompanyCd(user.getCompanyCd());
        }
        
        return dto;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles(user.getUserType().name())
                .build();
    }

    @Transactional
    public void register(MemberDto dto) {
        User user = new User();
        user.setUserId(dto.getUserId());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setUserName(dto.getUserName());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        user.setPosition(dto.getPosition());
        
        // 주소 저장 (화면에서 넘어온 postcode, address 필드를 사용) [cite: 16]
        user.setPostcode(dto.getPostcode());
        user.setAddress(dto.getAddress());
        user.setDetailAddress(dto.getDetailAddress());

        if (dto.getUserType() != null) {
            user.setUserType(UserType.valueOf(dto.getUserType()));
        }

        if ("MASTER".equals(dto.getUserType())) {
            user.setIsRepresentative("Y");
            user.setBusinessNumber(dto.getBusinessNumber());
            user.setCompanyCd(dto.getCompanyName()); // 대표가 입력한 회사명 저장 [cite: 16]
        } else {
            user.setIsRepresentative("N");
            user.setCompanyCd(dto.getCompanyCd());
        }

        user.setRegId("SYSTEM");
        user.setUpdId("SYSTEM");
        userRepository.save(user);
    }
    
    @Transactional
    public void updateInfo(MemberDto dto) {
        // 1. 기존 사용자 정보를 ID(또는 이메일)로 확실하게 조회
        // MemberController에서 넘겨준 DTO에 email이나 userId가 반드시 포함되어 있어야 합니다.
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다."));

        // 2. 스냅샷 데이터와 비교하여 변경된 내용 반영
        user.setUserName(dto.getUserName());
        user.setPhone(dto.getPhone());
        user.setPosition(dto.getPosition());
        user.setPostcode(dto.getPostcode());
        user.setAddress(dto.getAddress());
        user.setDetailAddress(dto.getDetailAddress());

        // 비밀번호 수정 로직 (입력값이 있을 때만)
        if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
        }

        // 3. 명시적 저장 (변경 감지가 안 될 경우를 대비)
        userRepository.save(user);
    }
}