package com.example.ProductService.command.api.controller;

import com.example.ProductService.command.api.commands.CreateProductCommand;
import com.example.ProductService.command.api.model.ProductRestModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;

import static org.hamcrest.Matchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
@WebMvcTest(ProductCommandController.class)
public class ProductCommandControllerTest {

    @MockBean
    private CommandGateway commandGateway;
    @Autowired
    private MockMvc mockMvc;
    @InjectMocks
    private ProductCommandController productCommandController;

    @Test
    void shouldCreateProduct() throws Exception {
        ProductRestModel productRestModel = ProductRestModel.builder()
                .name("Test Product")
                .price(BigDecimal.valueOf(100))
                .quantity(50)
                .build();

        when(commandGateway.sendAndWait(any(CreateProductCommand.class))).thenReturn("123");

        mockMvc.perform(post("/products")
                .content(asJsonString(productRestModel))
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());

        verify(commandGateway).sendAndWait(any(CreateProductCommand.class));
    }

    public static String asJsonString(final Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}