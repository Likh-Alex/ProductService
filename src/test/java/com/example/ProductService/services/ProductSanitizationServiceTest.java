package com.example.ProductService.services;

import com.example.ProductService.command.api.model.ProductRestModel;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class ProductSanitizationServiceTest {

    /**
     * This class tests the sanitize method of the ProductSanitizationService class.
     * The sanitize method is responsible for sanitizing a ProductRestModel object by trimming the name,
     * setting the price and quantity to zero if null or negative.
     * Each test case focuses on a single use case for clarity and readability.
     */

    @Test
    void sanitize_nullProduct_test() {
        ProductSanitizationService service = new ProductSanitizationService();
        ProductRestModel product = null;

        // The sanitize method should safely handle null values and return null.
        assertEquals(null, service.sanitize(product));
    }

    @Test
    void sanitize_negativePrice_test() {
        ProductSanitizationService service = new ProductSanitizationService();
        ProductRestModel product = ProductRestModel.builder()
                .name("Test Price Product")
                .price(BigDecimal.valueOf(-10))
                .quantity(10)
                .build();

        // The sanitize method should set negative prices to zero.
        assertEquals(BigDecimal.ZERO, service.sanitize(product).getPrice());
    }

    @Test
    void sanitize_nullPrice_test() {
        ProductSanitizationService service = new ProductSanitizationService();
        ProductRestModel product = ProductRestModel.builder()
                .name("Test Price Product")
                .price(null)
                .quantity(10)
                .build();

        // The sanitize method should set null prices to zero.
        assertEquals(BigDecimal.ZERO, service.sanitize(product).getPrice());
    }

    @Test
    void sanitize_negativeQuantity_test() {
        ProductSanitizationService service = new ProductSanitizationService();
        ProductRestModel product = ProductRestModel.builder()
                .name("Test Quantity Product")
                .price(BigDecimal.TEN)
                .quantity(-10)
                .build();

        // The sanitize method should set negative quantities to zero.
        assertEquals(0, service.sanitize(product).getQuantity());
    }

    @Test
    void sanitize_nullQuantity_test() {
        ProductSanitizationService service = new ProductSanitizationService();
        ProductRestModel product = ProductRestModel.builder()
                .name("Test Quantity Product")
                .price(BigDecimal.TEN)
                .quantity(null)
                .build();

        // The sanitize method should set null quantities to zero.
        assertEquals(0, service.sanitize(product).getQuantity());
    }

}