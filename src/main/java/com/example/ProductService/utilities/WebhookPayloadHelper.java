package com.example.ProductService.utilities;

import com.example.ProductService.webhook.model.ProductWebhookModel;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

public class WebhookPayloadHelper {

    /**
     * Builds the webhook payload for a product.
     *
     * @param product       the product webhook model
     * @param apiGatewayUrl the API Gateway URL
     * @return the JSON payload as a string
     */
    public static String buildWebhookPayload(ProductWebhookModel product, String apiGatewayUrl) {
        Map<String, Object> payload = new HashMap<>();

        Map<String, Object> productMap = new HashMap<>();
        productMap.put("name", product.getName());
        productMap.put("price", product.getPrice());
        productMap.put("quantity", product.getQuantity());

        payload.put("product", productMap);
        payload.put("api_gateway_url", apiGatewayUrl);

        Gson gson = new Gson();
        return gson.toJson(payload);
    }
}
