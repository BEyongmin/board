package com.board.board.user;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service 
@RequiredArgsConstructor 
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional 
    public void signup(SignupRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalStateException("이미 사용 중인 이메일입니다.");
        }
        String encodedPassword = passwordEncoder.encode(request.getPassword());
        User user = User.create(request.getEmail(), encodedPassword, request.getName());
        userRepository.save(user);
    }
}
