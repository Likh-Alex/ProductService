package com.example.ProductService.command.api.commands;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import org.axonframework.modelling.command.TargetAggregateIdentifier;

import java.math.BigDecimal;

@Data
@Builder
@AllArgsConstructor
public class CreateProductCommand {

    @TargetAggregateIdentifier
    private String productId;
    private String name;
    private BigDecimal price;
    private Integer quantity;
}
