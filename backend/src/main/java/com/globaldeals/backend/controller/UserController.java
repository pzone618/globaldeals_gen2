package com.globaldeals.backend.controller;

import com.globaldeals.backend.dto.UserResponse;
import com.globaldeals.backend.entity.User;
import com.globaldeals.backend.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * User controller for protected endpoints
 * 
 * @author Tech Lead
 * @since 1.0.0
 */
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserMapper userMapper;

    /**
     * Get current user profile
     * 
     * @param authentication current authentication
     * @return current user information
     */
    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        UserResponse response = userMapper.toResponse(user);
        return ResponseEntity.ok(response);
    }

    /**
     * Protected endpoint for testing authentication
     * 
     * @param authentication current authentication
     * @return welcome message
     */
    @GetMapping("/dashboard")
    public ResponseEntity<String> getDashboard(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        return ResponseEntity.ok("Welcome to your dashboard, " + user.getUsername() + "!");
    }
}
