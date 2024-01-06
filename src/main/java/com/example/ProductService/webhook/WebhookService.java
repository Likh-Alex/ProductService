package com.example.ProductService.webhook;

import com.example.ProductService.utilities.ProductHelper;
import com.example.ProductService.utilities.WebhookPayloadHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class WebhookService {
    private final RestTemplate restTemplate;

    @Value("${webhook.url}")
    private String url = "";

    @Value("${aws.api.gateway.url}")
    private String apiGatewayUrl;

    public WebhookService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Sends a webhook request to the specified URL with a randomly generated product payload.
     */
    public void setWebhook() {
        ProductHelper productHelper = new ProductHelper();
        String jsonPayload = WebhookPayloadHelper.buildWebhookPayload(productHelper.buildRandomProduct(), apiGatewayUrl + "products");
        restTemplate.postForObject(url, jsonPayload, String.class);
    }

}
