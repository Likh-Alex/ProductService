package com.example.ProductService.query.api.projection;

import com.example.ProductService.command.api.data.Product;
import com.example.ProductService.command.api.data.ProductRepository;
import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.axonframework.queryhandling.QueryHandler;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

public class ProductProjectionTest {

    @Test
    void handle_noProductsInRepository_returnsEmptyList() {
        // arrange
        ProductRepository mockProductRepository = Mockito.mock(ProductRepository.class);
        when(mockProductRepository.findAll()).thenReturn(Collections.emptyList());
        ProductProjection productProjection = new ProductProjection(mockProductRepository);

        // act
        List<ProductRestModel> result = productProjection.handle(new GetProductQuery());

        // assert
        assertThat(result).isEmpty();
    }

    @Test
    void handle_oneProductInRepository_returnsListWithOneRestModel() {
        // arrange
        Product product = new Product();
        product.setName("test product");
        product.setPrice(BigDecimal.valueOf(10));
        product.setQuantity(5);

        ProductRepository mockProductRepository = Mockito.mock(ProductRepository.class);
        when(mockProductRepository.findAll()).thenReturn(Collections.singletonList(product));

        ProductProjection productProjection = new ProductProjection(mockProductRepository);

        // act
        List<ProductRestModel> result = productProjection.handle(new GetProductQuery());

        // assert
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo(product.getName());
        assertThat(result.get(0).getPrice()).isEqualTo(product.getPrice());
        assertThat(result.get(0).getQuantity()).isEqualTo(product.getQuantity());
    }
}