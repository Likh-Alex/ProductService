package com.example.ProductService.command.api.controller;

import com.example.ProductService.command.api.commands.CreateProductCommand;
import com.example.ProductService.command.api.model.ProductRestModel;
import org.axonframework.commandhandling.gateway.CommandGateway;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class ProductCommandControllerTest {

    @Mock
    private CommandGateway commandGateway;

    private ProductCommandController controller;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
        controller = new ProductCommandController(commandGateway);
    }

    @Test
    void shouldSendCreateProductCommand() {
        ProductRestModel productRestModel = new ProductRestModel("Test Product", BigDecimal.valueOf(10.0), 5);
        when(commandGateway.sendAndWait(any(CreateProductCommand.class))).thenReturn("Success");

        String response = controller.addProduct(productRestModel);

        assertEquals("Success", response);
        verify(commandGateway, times(1)).sendAndWait(any(CreateProductCommand.class));
    }
}
