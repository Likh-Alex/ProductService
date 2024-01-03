package com.example.ProductService.services;

import com.example.ProductService.command.api.model.ProductRestModel;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class ProductSanitizationService {

    /**
     * Sanitizes a ProductRestModel object by trimming the name, setting the price to zero if it is null or negative,
     * and setting the quantity to zero if it is null or negative.
     *
     * @param product The ProductRestModel to be sanitized.
     * @return The sanitized ProductRestModel.
     */
    public static ProductRestModel sanitize(ProductRestModel product) {
        if (product != null) {
            String name = product.getName() == null ? "" : product.getName().trim();
            product.setName(name);

            BigDecimal price = product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) < 0
                    ? BigDecimal.ZERO
                    : product.getPrice();
            product.setPrice(price);

            Integer quantity = product.getQuantity() == null || product.getQuantity() < 0
                    ? 0
                    : product.getQuantity();
            product.setQuantity(quantity);
        }

        return product;
    }
}
