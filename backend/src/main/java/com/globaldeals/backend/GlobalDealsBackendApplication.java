package com.globaldeals.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Global Deals Backend Application
 * 
 * @author Tech Lead
 * @since 1.0.0
 */
@SpringBootApplication
@ConfigurationPropertiesScan
public class GlobalDealsBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(GlobalDealsBackendApplication.class, args);
    }
}
