package com.example.ProductService.query.api.projection;

import static org.mockito.Mockito.when;
import static org.junit.jupiter.api.Assertions.assertEquals;

import com.example.ProductService.command.api.data.Product;
import com.example.ProductService.command.api.data.ProductRepository;
import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;
import java.util.List;
import java.util.Arrays;

class ProductProjectionTest {

    @Mock
    private ProductRepository productRepository;

    private ProductProjection productProjection;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
        productProjection = new ProductProjection(productRepository);
    }

    @Test
    void shouldReturnListOfProductRestModels() {
        List<Product> products = Arrays.asList(
                new Product("1", "Product1", BigDecimal.valueOf(100.0), 10),
                new Product("2", "Product2", BigDecimal.valueOf(200.0), 20)
        );
        when(productRepository.findAll()).thenReturn(products);

        List<ProductRestModel> result = productProjection.handle(new GetProductQuery());

        assertEquals(2, result.size());
        assertEquals("Product1", result.get(0).getName());
        assertEquals(BigDecimal.valueOf(100.0), result.get(0).getPrice());
        assertEquals(10, result.get(0).getQuantity());
    }
}
