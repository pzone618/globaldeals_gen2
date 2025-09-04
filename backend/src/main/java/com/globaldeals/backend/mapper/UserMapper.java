package com.globaldeals.backend.mapper;

import com.globaldeals.backend.dto.RegisterRequest;
import com.globaldeals.backend.dto.UserResponse;
import com.globaldeals.backend.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

/**
 * MapStruct mapper for User entity and DTOs
 * 
 * @author Tech Lead
 * @since 1.0.0
 */
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface UserMapper {

    /**
     * Convert RegisterRequest to User entity
     * 
     * @param request the registration request
     * @return User entity
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "enabled", constant = "true")
    @Mapping(target = "accountNonExpired", constant = "true")
    @Mapping(target = "accountNonLocked", constant = "true")
    @Mapping(target = "credentialsNonExpired", constant = "true")
    @Mapping(target = "role", constant = "USER")
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    User toEntity(RegisterRequest request);

    /**
     * Convert User entity to UserResponse
     * 
     * @param user the user entity
     * @return UserResponse DTO
     */
    @Mapping(target = "role", expression = "java(user.getRole().name())")
    UserResponse toResponse(User user);
}
