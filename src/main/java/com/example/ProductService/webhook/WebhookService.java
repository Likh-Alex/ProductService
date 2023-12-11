package com.example.ProductService.webhook;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.util.StreamUtils;

import java.nio.charset.StandardCharsets;
import java.io.IOException;

@Service
public class WebhookService {

    public static final String CLASSPATH_DEFAULT_DATA_DEFAULT_PRODUCTS_JSON = "classpath:defaultData/default_products.json";
    private final RestTemplate restTemplate;
    private final ResourceLoader resourceLoader;
    @Value("${webhook.endpoint}")
    private String endpoint;
    @Value("${webhook.baseUrl}")
    private String baseUrl;

    public WebhookService(ResourceLoader resourceLoader, RestTemplate restTemplate) {
        this.resourceLoader = resourceLoader;
        this.restTemplate = restTemplate;
    }

    public void sendPostWebhook() throws IOException {
        Resource resource = resourceLoader.getResource(CLASSPATH_DEFAULT_DATA_DEFAULT_PRODUCTS_JSON);
        String webhookUrl = baseUrl + endpoint;
        String jsonPayload;
        try {
            jsonPayload = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
            restTemplate.postForObject(webhookUrl, jsonPayload, String.class);
        } catch (IOException exception) {
            exception.printStackTrace();
        }


    }
}
