package io.github.teamb.btob.service.member;

import io.github.teamb.btob.dto.member.MemberDto;
import io.github.teamb.btob.entity.User;
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

    // 마이페이지 정보 조회
    @Transactional(readOnly = true)
    public MemberDto getMyInfo(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다."));
        
        MemberDto dto = new MemberDto();
        dto.setUserId(user.getUserId());
        dto.setUserName(user.getUserName());
        dto.setEmail(user.getEmail());
        dto.setPhone(user.getPhone());
        
        // 이제 엔티티에 필드가 추가되었으므로 에러가 발생하지 않습니다.
        dto.setPosition(user.getPosition());
        dto.setAddress(user.getAddress());
        dto.setBusinessNumber(user.getBusinessNumber());
        dto.setIsRepresentative(user.getIsRepresentative());
        
        return dto;
    }

    // 정보 수정
    @Transactional
    public void updateInfo(MemberDto dto) {
        // 1. 기존 DB에서 사용자 정보 조회 (이메일 기준)
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        // 2. 전달받은 DTO의 데이터로 엔티티 값 변경
        user.setUserName(dto.getUserName());
        user.setPhone(dto.getPhone()); // 이 값이 null이면 에러 발생
        user.setPosition(dto.getPosition());
        user.setAddress(dto.getAddress());
        
        // 추가 필드가 있다면 여기에 작성
        if(dto.getBusinessNumber() != null) {
            user.setBusinessNumber(dto.getBusinessNumber());
        }
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
        user.setRegId("SYSTEM");
        user.setUpdId("SYSTEM");
        userRepository.save(user);
    }
}