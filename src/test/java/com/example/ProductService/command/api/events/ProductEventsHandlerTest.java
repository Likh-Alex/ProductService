package com.example.ProductService.command.api.events;

import com.example.ProductService.command.api.data.ProductWriteModel;
import com.example.ProductService.command.api.data.ProductWriteModelRepository;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class ProductEventsHandlerTest {

    @Test
    public void testOnWithValidProductCreatedEvent() throws Exception {
        // Given
        ProductCreatedEvent productCreatedEvent = new ProductCreatedEvent();
        productCreatedEvent.setProductId("123");
        productCreatedEvent.setName("Test Product");
        productCreatedEvent.setPrice(BigDecimal.valueOf(10.0));
        productCreatedEvent.setQuantity(5);

        ProductWriteModelRepository productRepositoryMock = Mockito.mock(ProductWriteModelRepository.class);
        Mockito.when(productRepositoryMock.save(Mockito.any())).thenAnswer(invocation -> invocation.getArgument(0));

        ProductEventsHandler productEventsHandler = new ProductEventsHandler(productRepositoryMock);

        // When
        productEventsHandler.on(productCreatedEvent);

        // Then
        ArgumentCaptor<ProductWriteModel> argumentCaptor = ArgumentCaptor.forClass(ProductWriteModel.class);
        Mockito.verify(productRepositoryMock, Mockito.times(1)).save(argumentCaptor.capture());
        ProductWriteModel savedProduct = argumentCaptor.getValue();

        assertEquals(productCreatedEvent.getProductId(), savedProduct.getProductId());
        assertEquals(productCreatedEvent.getName(), savedProduct.getName());
        assertEquals(productCreatedEvent.getPrice(), savedProduct.getPrice());
        assertEquals(productCreatedEvent.getQuantity(), savedProduct.getQuantity());
    }

    @Test
    public void testOnWithException() throws Exception {
        ProductWriteModel product = new ProductWriteModel();
        ProductWriteModelRepository productRepositoryMock = Mockito.mock(ProductWriteModelRepository.class);
        Mockito.when(productRepositoryMock.save(Mockito.any())).thenThrow(new RuntimeException());

        ProductEventsHandler productEventsHandler = new ProductEventsHandler(productRepositoryMock);
        ProductCreatedEvent productCreatedEvent = new ProductCreatedEvent();

        assertThrows(Exception.class, () -> {
            productEventsHandler.on(productCreatedEvent);
        });
        Mockito.verify(productRepositoryMock, Mockito.times(1)).save(Mockito.any());
    }
}