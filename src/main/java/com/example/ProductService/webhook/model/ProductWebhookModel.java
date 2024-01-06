package com.example.ProductService.webhook.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ProductWebhookModel {
    private String name;
    private BigDecimal price;
    private Integer quantity;
}
