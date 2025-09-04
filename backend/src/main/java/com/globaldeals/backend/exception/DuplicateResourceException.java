package com.globaldeals.backend.exception;

/**
 * Exception thrown when creating a resource that already exists (e.g., duplicate username/email).
 */
public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}
