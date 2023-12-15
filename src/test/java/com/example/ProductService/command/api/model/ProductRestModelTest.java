package com.example.ProductService.command.api.model;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ProductRestModelTest {

    @Test
    void testProductRestModel() {
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(20.0);
        Integer quantity = 10;

        ProductRestModel productRestModel = new ProductRestModel();
        productRestModel.setName(name);
        productRestModel.setPrice(price);
        productRestModel.setQuantity(quantity);

        assertEquals(name, productRestModel.getName());
        assertEquals(price, productRestModel.getPrice());
        assertEquals(quantity, productRestModel.getQuantity());
    }

    @Test
    void testProductRestModelBuilder() {
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(20.0);
        Integer quantity = 10;

        ProductRestModel productRestModel = ProductRestModel.builder()
                .name(name)
                .price(price)
                .quantity(quantity)
                .build();

        assertEquals(name, productRestModel.getName());
        assertEquals(price, productRestModel.getPrice());
        assertEquals(quantity, productRestModel.getQuantity());
    }
}
