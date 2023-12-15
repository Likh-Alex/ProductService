package com.example.ProductService.command.api.commands;

import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.*;

class CreateProductCommandTest {

    @Test
    void testCreateProductCommand() {
        String productId = "p123";
        String name = "Product Name";
        BigDecimal price = BigDecimal.valueOf(100.0);
        Integer quantity = 5;

        CreateProductCommand command = CreateProductCommand.builder()
                .productId(productId)
                .name(name)
                .price(price)
                .quantity(quantity)
                .build();

        assertEquals(productId, command.getProductId());
        assertEquals(name, command.getName());
        assertEquals(price, command.getPrice());
        assertEquals(quantity, command.getQuantity());
    }
}
