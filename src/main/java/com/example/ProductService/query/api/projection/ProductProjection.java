package com.example.ProductService.query.api.projection;

import com.example.ProductService.command.api.events.ProductCreatedEvent;
import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.data.ProductReadModel;
import com.example.ProductService.query.api.data.ProductReadModelRepository;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.axonframework.eventhandling.EventHandler;
import org.axonframework.queryhandling.QueryHandler;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ProductProjection {
    private ProductReadModelRepository productRepository;

    public ProductProjection(ProductReadModelRepository productRepository) {
        this.productRepository = productRepository;
    }

    @QueryHandler
    public List<ProductRestModel> handle(GetProductQuery getProductQuery) {
        List<ProductReadModel> products = productRepository.findAll();
        List<ProductRestModel> productRestModels = products.stream().map(product ->
                ProductRestModel.builder()
                        .name(product.getName())
                        .price(product.getPrice())
                        .quantity(product.getQuantity()).build()
        ).collect(Collectors.toList());

        return productRestModels;
    }

    @EventHandler
    public void on(ProductCreatedEvent event) {
        ProductReadModel productReadModel = new ProductReadModel(event.getProductId(), event.getName(), event.getPrice(), event.getQuantity());
        productRepository.save(productReadModel);
    }

}
