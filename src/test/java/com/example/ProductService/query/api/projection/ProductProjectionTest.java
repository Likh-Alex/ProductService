package com.example.ProductService.query.api.projection;

import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.data.ProductReadModel;
import com.example.ProductService.query.api.data.ProductReadModelRepository;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

class ProductProjectionTest {

    @Mock
    private ProductReadModelRepository productRepository;

    private ProductProjection productProjection;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
        productProjection = new ProductProjection(productRepository);
    }

    @Test
    void shouldReturnListOfProductRestModels() {
        List<ProductReadModel> products = Arrays.asList(
                new ProductReadModel("1", "Product1", BigDecimal.valueOf(100.0), 10),
                new ProductReadModel("2", "Product2", BigDecimal.valueOf(200.0), 20)
        );
        when(productRepository.findAll()).thenReturn(products);

        List<ProductRestModel> result = productProjection.handle(new GetProductQuery());

        assertEquals(2, result.size());
        assertEquals("Product1", result.get(0).getName());
        assertEquals(BigDecimal.valueOf(100.0), result.get(0).getPrice());
        assertEquals(10, result.get(0).getQuantity());
    }
}
