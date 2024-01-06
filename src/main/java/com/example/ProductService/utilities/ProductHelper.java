package com.example.ProductService.utilities;

import com.example.ProductService.statics.DefaultProductNames;
import com.example.ProductService.webhook.model.ProductWebhookModel;

import java.math.BigDecimal;
import java.util.Random;

public class ProductHelper {

    /**
     * Build a random product with random price, quantity, and name.
     *
     * @return a ProductWebhookModel object representing the random product.
     */
    public ProductWebhookModel buildRandomProduct() {
        Random random = new Random();
        int price = random.nextInt(100);
        int quantity = random.nextInt(100);
        int productNumber = random.nextInt(100);
        ProductWebhookModel product = new ProductWebhookModel();

        product.setName(retrieveRandomName(productNumber));
        product.setPrice(BigDecimal.valueOf(price));
        product.setQuantity(quantity);


        return product;
    }

    /**
     * Retrieves a random name from a list of default product names.
     *
     * @param productNumber the product number used to retrieve the name from the list
     * @return the randomly selected name
     */
    public String retrieveRandomName(int productNumber) {
        String[] names = DefaultProductNames.FRUITS_AND_VEGETABLES;
        return names[productNumber];
    }
}
