package com.example.ProductService.query.api.controller;

import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.controller.ProductQueryController;
import org.axonframework.messaging.responsetypes.ResponseTypes;
import org.axonframework.queryhandling.QueryGateway;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@WebMvcTest(ProductQueryController.class)
public class ProductQueryControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private QueryGateway queryGateway;

    @Test
    void getAllProducts() throws Exception {

        // given
        var productRestModels = Collections.singletonList(
                ProductRestModel.builder().build()
        );

        //Create a new CompletableFuture instance
        CompletableFuture<List<ProductRestModel>> future = CompletableFuture.completedFuture(productRestModels);

        Mockito.when(
                queryGateway.query(Mockito.any(), Mockito.eq(ResponseTypes.multipleInstancesOf(ProductRestModel.class)))
        ).thenReturn(future); //Return the future instance

        // when, then
        this.mockMvc.perform(get("/products"))
                .andExpect(status().isOk());

        Mockito.verify(queryGateway, Mockito.times(1)).query(Mockito.any(), Mockito.eq(ResponseTypes.multipleInstancesOf(ProductRestModel.class)));
    }
} 