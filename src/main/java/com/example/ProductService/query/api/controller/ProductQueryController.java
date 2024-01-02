package com.example.ProductService.query.api.controller;

import com.example.ProductService.command.api.model.ProductRestModel;
import com.example.ProductService.query.api.queries.GetProductQuery;
import org.axonframework.messaging.responsetypes.ResponseTypes;
import org.axonframework.queryhandling.QueryGateway;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ProductQueryController {

    private QueryGateway queryGateway;

    ProductQueryController(QueryGateway queryGateway) {
        this.queryGateway = queryGateway;
    }

    @GetMapping("/products")
    public List<ProductRestModel> getAllProducts() {
        GetProductQuery getProductQuery = new GetProductQuery();
        List<ProductRestModel> productRestModels = queryGateway.query(getProductQuery, ResponseTypes.multipleInstancesOf(ProductRestModel.class))
                .join();

        return productRestModels;
    }
}
