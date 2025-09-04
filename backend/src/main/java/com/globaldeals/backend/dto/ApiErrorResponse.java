package com.globaldeals.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

/**
 * Standard API error response wrapper.
 */
@Data
@AllArgsConstructor
@Builder
public class ApiErrorResponse {
    private boolean success;
    private String message;
}
