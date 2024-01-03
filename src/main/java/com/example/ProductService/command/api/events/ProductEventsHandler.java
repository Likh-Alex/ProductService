package com.example.ProductService.command.api.events;

import com.example.ProductService.command.api.data.ProductWriteModel;
import com.example.ProductService.command.api.data.ProductWriteModelRepository;
import org.axonframework.config.ProcessingGroup;
import org.axonframework.eventhandling.EventHandler;
import org.axonframework.messaging.interceptors.ExceptionHandler;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Component;

@Component
@ProcessingGroup("product")
public class ProductEventsHandler {

    private ProductWriteModelRepository productRepository;

    public ProductEventsHandler(ProductWriteModelRepository productRepository) {
        this.productRepository = productRepository;
    }

    @EventHandler
    public void on(ProductCreatedEvent event) throws Exception {
        ProductWriteModel product = new ProductWriteModel();
        BeanUtils.copyProperties(event, product);
        productRepository.save(product);
    }

    @ExceptionHandler
    public void handle(Exception exception) throws Exception {
        throw exception;
    }
}

