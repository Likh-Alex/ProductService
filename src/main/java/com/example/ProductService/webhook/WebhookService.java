package com.example.ProductService.webhook;

import org.springframework.core.env.Environment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Service
public class WebhookService {
    public static final String DEV = "dev";
    @Autowired
    private Environment env;
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
        if (isDevProfile()) {
            return;
        }
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

    private boolean isDevProfile() {
        if (env == null) {
            return false;
        }
        String[] activeProfiles = env.getActiveProfiles();
        return activeProfiles.length > 0 && activeProfiles[0].equals(DEV);
    }
}
