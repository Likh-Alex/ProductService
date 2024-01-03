package com.example.ProductService.query.api.data;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.math.BigDecimal;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
public class ProductReadModel {
    @Id
    private String productId;
    private String name;
    private BigDecimal price;
    private Integer quantity;
}
