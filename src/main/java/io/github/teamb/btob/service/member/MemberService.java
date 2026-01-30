package io.github.teamb.btob.service.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.entity.User;
import io.github.teamb.btob.entity.UserType; // UserType Enum 임포트 확인
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
        dto.setAddress(user.getAddress());
        dto.setPostcode(user.getPostcode()); // 필드 추가됨
        dto.setDetailAddress(user.getDetailAddress()); // 필드 추가됨
        dto.setBusinessNumber(user.getBusinessNumber());
        dto.setIsRepresentative(user.getIsRepresentative());
        
        return dto;
    }

    @Transactional
    public void updateInfo(MemberDto dto) {
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        user.setUserName(dto.getUserName());
        user.setPhone(dto.getPhone());
        user.setPosition(dto.getPosition());
        user.setAddress(dto.getAddress());
        user.setPostcode(dto.getPostcode());
        user.setDetailAddress(dto.getDetailAddress());
        
        if(dto.getBusinessNumber() != null) {
            user.setBusinessNumber(dto.getBusinessNumber());
        }
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));

        // .roles() 메서드가 DB의 "ADMIN"을 "ROLE_ADMIN"으로 자동 변환해줍니다.
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
        
        // --- 데이터 누락 해결 부분 ---
        user.setPosition(dto.getPosition());
        user.setPostcode(dto.getPostcode());
        user.setAddress(dto.getAddress());
        user.setDetailAddress(dto.getDetailAddress());
        user.setBusinessNumber(dto.getBusinessNumber());
        user.setIsRepresentative(dto.getIsRepresentative());

        // String(DTO) -> UserType Enum(Entity) 변환 로직
        if (dto.getUserType() != null) {
            user.setUserType(UserType.valueOf(dto.getUserType()));
        }
        // -----------------------

        user.setRegId("SYSTEM");
        user.setUpdId("SYSTEM");
        userRepository.save(user);
    }
}