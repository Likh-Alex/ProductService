package com.example.ProductService.command.api.events;

import com.example.ProductService.command.api.data.Product;
import com.example.ProductService.command.api.data.ProductRepository;
import com.example.ProductService.command.api.events.ProductCreatedEvent;
import com.example.ProductService.command.api.events.ProductEventsHandler;
import org.axonframework.eventhandling.GenericEventMessage;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class ProductEventsHandlerTest {

    @Test
    public void testOnWithValidProductCreatedEvent() throws Exception {
        Product product = new Product();
        ProductRepository productRepositoryMock = Mockito.mock(ProductRepository.class);
        Mockito.when(productRepositoryMock.save(Mockito.any())).thenReturn(product);

        ProductEventsHandler productEventsHandler = new ProductEventsHandler(productRepositoryMock);
        ProductCreatedEvent productCreatedEvent = new ProductCreatedEvent();

        assertThrows(Exception.class, () -> {
            productEventsHandler.on(productCreatedEvent);
        });

        Mockito.verify(productRepositoryMock, Mockito.times(1)).save(Mockito.any());
    }

    @Test
    public void testOnWithException() throws Exception {
        Product product = new Product();
        ProductRepository productRepositoryMock = Mockito.mock(ProductRepository.class);
        Mockito.when(productRepositoryMock.save(Mockito.any())).thenThrow(new RuntimeException());

        ProductEventsHandler productEventsHandler = new ProductEventsHandler(productRepositoryMock);
        ProductCreatedEvent productCreatedEvent = new ProductCreatedEvent();

        assertThrows(Exception.class, () -> {
            productEventsHandler.on(productCreatedEvent);
        });
        Mockito.verify(productRepositoryMock, Mockito.times(1)).save(Mockito.any());
    }
}