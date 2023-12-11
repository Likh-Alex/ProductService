package com.example.ProductService.command.api.aggreagte;

import com.example.ProductService.command.api.commands.CreateProductCommand;
import com.example.ProductService.command.api.events.ProductCreatedEvent;
import org.axonframework.eventsourcing.eventstore.EventStore;
import org.axonframework.test.aggregate.AggregateTestFixture;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

public class ProductAggregateUnitTest {

    private AggregateTestFixture<ProductAggregate> testFixture;

    public ProductAggregateUnitTest() {
        this.testFixture = new AggregateTestFixture<>(ProductAggregate.class);
    }

    @Test
    public void givenCreateProductCommand_thenShouldPublishProductCreatedEvent() {
        String productId = "product-1";
        String name = "Product Name";
        BigDecimal price = new BigDecimal(100);
        Integer quantity = 10;
        CreateProductCommand cmd = CreateProductCommand.builder()
                                                .productId(productId)
                                                .name(name)
                                                .price(price)
                                                .quantity(quantity)
                                                .build(); 

        testFixture.givenNoPriorActivity()
                   .when(cmd)
                   .expectEvents(new ProductCreatedEvent(productId, name, price, quantity));
    }
}