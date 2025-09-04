package com.globaldeals.backend.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * JWT 配置属性
 */
@ConfigurationProperties(prefix = "jwt")
public record JwtProperties(
    String secret,
    Long expiration,
    Long refreshExpiration
) {
    public JwtProperties {
        // 提供默认值
        if (secret == null || secret.isBlank()) {
            secret = "mySecretKey123456789012345678901234567890123456789012345678901234567890";
        }
        if (expiration == null) {
            expiration = 86400000L; // 24小时
        }
        if (refreshExpiration == null) {
            refreshExpiration = 604800000L; // 7天
        }
    }
}
