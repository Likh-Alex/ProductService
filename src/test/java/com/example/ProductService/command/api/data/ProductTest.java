package com.example.ProductService.command.api.data;

import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import static org.junit.jupiter.api.Assertions.assertEquals;

class ProductTest {

    @Test
    void testProductEntity() {
        String productId = "prod123";
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(20.0);
        Integer quantity = 10;

        Product product = new Product();
        product.setProductId(productId);
        product.setName(name);
        product.setPrice(price);
        product.setQuantity(quantity);

        assertEquals(productId, product.getProductId());
        assertEquals(name, product.getName());
        assertEquals(price, product.getPrice());
        assertEquals(quantity, product.getQuantity());
    }
}