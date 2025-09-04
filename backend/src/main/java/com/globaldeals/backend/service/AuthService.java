package com.globaldeals.backend.service;

import com.globaldeals.backend.dto.AuthResponse;
import com.globaldeals.backend.dto.LoginRequest;
import com.globaldeals.backend.dto.RegisterRequest;
import com.globaldeals.backend.entity.User;
import com.globaldeals.backend.mapper.UserMapper;
import com.globaldeals.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.globaldeals.backend.exception.DuplicateResourceException;

/**
 * Service for authentication operations
 * 
 * @author Tech Lead
 * @since 1.0.0
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /**
     * Register a new user
     * 
     * @param request the registration request
     * @return authentication response with tokens
     * @throws RuntimeException if username or email already exists
     */
    @Transactional(readOnly = false)
    public AuthResponse register(RegisterRequest request) {
        log.info("Attempting to register user with username: {}", request.getUsername());
        
        // Check if username already exists
        if (userRepository.existsByUsername(request.getUsername())) {
            log.warn("Registration failed: username already exists: {}", request.getUsername());
            throw new DuplicateResourceException("Username already exists");
        }
        
        // Check if email already exists
        if (userRepository.existsByEmail(request.getEmail())) {
            log.warn("Registration failed: email already exists: {}", request.getEmail());
            throw new DuplicateResourceException("Email already exists");
        }
        
        // Create new user
        User user = userMapper.toEntity(request);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        
        User savedUser = userRepository.save(user);
        log.info("User registered successfully: {}", savedUser.getUsername());
        
        // Generate tokens
        String accessToken = jwtService.generateToken(savedUser);
        String refreshToken = jwtService.generateRefreshToken(savedUser);
        
        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .user(userMapper.toResponse(savedUser))
                .build();
    }

    /**
     * Authenticate user and generate tokens
     * 
     * @param request the login request
     * @return authentication response with tokens
     */
    public AuthResponse login(LoginRequest request) {
        log.info("Attempting to authenticate user: {}", request.getUsername());
        
        // Authenticate user
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );
        
        User user = (User) authentication.getPrincipal();
        log.info("User authenticated successfully: {}", user.getUsername());
        
        // Generate tokens
        String accessToken = jwtService.generateToken(user);
        String refreshToken = jwtService.generateRefreshToken(user);
        
        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .user(userMapper.toResponse(user))
                .build();
    }

    /**
     * Refresh access token using refresh token
     * 
     * @param refreshToken the refresh token
     * @return new authentication response with tokens
     */
    public AuthResponse refreshToken(String refreshToken) {
        log.info("Attempting to refresh token");
        
        String username = jwtService.extractUsername(refreshToken);
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (jwtService.isTokenValid(refreshToken, user)) {
            String newAccessToken = jwtService.generateToken(user);
            String newRefreshToken = jwtService.generateRefreshToken(user);
            
            log.info("Token refreshed successfully for user: {}", user.getUsername());
            
            return AuthResponse.builder()
                    .accessToken(newAccessToken)
                    .refreshToken(newRefreshToken)
                    .user(userMapper.toResponse(user))
                    .build();
        } else {
            log.warn("Invalid refresh token for user: {}", username);
            throw new RuntimeException("Invalid refresh token");
        }
    }
}
