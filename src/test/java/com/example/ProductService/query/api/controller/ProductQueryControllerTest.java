package com.example.ProductService.query.api.controller;

import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.axonframework.messaging.responsetypes.ResponseTypes;
import org.axonframework.queryhandling.QueryGateway;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class ProductQueryControllerTest {

    @Mock
    private QueryGateway queryGateway;

    @InjectMocks
    private ProductQueryController controller;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    void shouldReturnAllProducts() {
        List<ProductRestModel> mockResponse = List.of(new ProductRestModel("Test Product", BigDecimal.valueOf(10.0), 5));
        when(queryGateway.query(any(GetProductQuery.class), eq(ResponseTypes.multipleInstancesOf(ProductRestModel.class))))
                .thenReturn(CompletableFuture.completedFuture(mockResponse));

        List<ProductRestModel> result = controller.getAllProducts();

        assertEquals(mockResponse.size(), result.size());
        verify(queryGateway).query(any(GetProductQuery.class), eq(ResponseTypes.multipleInstancesOf(ProductRestModel.class)));
    }

}
