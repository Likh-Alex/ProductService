package com.example.ProductService;

import com.example.ProductService.command.api.exception.ProductServiceEventsErrorHandler;
import org.axonframework.config.EventProcessingConfigurer;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class ProductServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }

    public void configure(EventProcessingConfigurer config) {
        config.registerListenerInvocationErrorHandler("product", conf -> new ProductServiceEventsErrorHandler());
    }
}
