package io.github.teamb.btob.service;

import io.github.teamb.btob.dto.MemberDto;
import io.github.teamb.btob.entity.*;
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

    @Transactional
    public void register(MemberDto dto) {
        User user = new User();
        user.setUserId(dto.getUserId());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setUserName(dto.getUserName());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        
        // 추가 필드 (User 엔티티에 해당 필드가 정의되어 있어야 함)
        // user.setPosition(dto.getPosition());
        // user.setAddress(dto.getAddress());
        // user.setBusinessNumber(dto.getBusinessNumber());
        
        user.setRegId("SYSTEM");
        user.setUpdId("SYSTEM");
        
        userRepository.save(user);
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
}
