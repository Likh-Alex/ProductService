package com.example.ProductService.command.api.aggreagte;

import com.example.ProductService.command.api.commands.CreateProductCommand;
import com.example.ProductService.command.api.events.ProductCreatedEvent;
import org.axonframework.test.aggregate.AggregateTestFixture;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

class ProductAggregateTest {

    private AggregateTestFixture<ProductAggregate> fixture;

    @BeforeEach
    void setUp() {
        fixture = new AggregateTestFixture<>(ProductAggregate.class);
    }

    @Test
    void shouldProduceProductCreatedEventOnCreateProductCommand() {
        String productId = "12345";
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(9.99);
        Integer quantity = 10;

        CreateProductCommand command = new CreateProductCommand(productId, name, price, quantity);
        ProductCreatedEvent expectedEvent = new ProductCreatedEvent(productId, name, price, quantity);

        fixture.givenNoPriorActivity()
                .when(command)
                .expectEvents(expectedEvent);
    }

    @Test
    void shouldHandleProductCreatedEvent() {
        String productId = "12345";
        String name = "Test Product";
        BigDecimal price = BigDecimal.valueOf(9.99);
        Integer quantity = 10;

        CreateProductCommand command = new CreateProductCommand(productId, name, price, quantity);

        fixture.given()
                .when(command)
                .expectSuccessfulHandlerExecution()
                .expectState(productAggregate -> {
                    assert productAggregate.getProductId().equals(productId);
                    assert productAggregate.getName().equals(name);
                    assert productAggregate.getPrice().equals(price);
                    assert productAggregate.getQuantity().equals(quantity);
                });
    }
}
