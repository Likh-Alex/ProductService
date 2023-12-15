package com.example.ProductService.command.api.events;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;


class ProductCreatedEventTest {

    @Test
    void testProductCreatedEvent() {
        String productId = "prod123";
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(20.0);
        Integer quantity = 10;

        ProductCreatedEvent productCreatedEvent = new ProductCreatedEvent();
        productCreatedEvent.setProductId(productId);
        productCreatedEvent.setName(name);
        productCreatedEvent.setPrice(price);
        productCreatedEvent.setQuantity(quantity);

        assertEquals(productId, productCreatedEvent.getProductId());
        assertEquals(name, productCreatedEvent.getName());
        assertEquals(price, productCreatedEvent.getPrice());
        assertEquals(quantity, productCreatedEvent.getQuantity());
    }
}