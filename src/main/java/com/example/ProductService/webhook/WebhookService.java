package com.example.ProductService.webhook;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    public static final String DEFAULT_PRODUCTS_JSON = "classpath:defaultData/default_products_payload.json";

    private final RestTemplate restTemplate;

    private final ResourceLoader resourceLoader;

    @Value("${webhook.url}")
    private String url = "";

    @Value("${aws.api.gateway.url}")
    private String apiGatewayUrl;

    private final Logger logger = LoggerFactory.getLogger(WebhookService.class);

    public WebhookService(ResourceLoader resourceLoader, RestTemplate restTemplate) {
        this.resourceLoader = resourceLoader;
        this.restTemplate = restTemplate;
    }

    /**
     * Sends a POST request to a specified URL with a JSON payload.
     *
     * @throws IOException if an I/O error occurs while reading the resource or sending the request
     */
    public void sendPostWebhook() throws IOException {
        Resource resource = resourceLoader.getResource(DEFAULT_PRODUCTS_JSON);
        String jsonPayload;
        try {
            jsonPayload = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
            restTemplate.postForObject(url, jsonPayload, String.class);
        } catch (IOException exception) {
            logger.error("Failed to send webhook request: {}", exception.getMessage(), exception);
        }
    }

    /**
     * Initializes the webhook data by sending a POST request to a specified URL with a JSON payload.
     *
     */
    public void setWebhook() {
        if (isDevProfile()) {
            logger.info("Skipping webhook request for dev profile");
            return;
        }

        try {
            Resource resource = resourceLoader.getResource(DEFAULT_PRODUCTS_JSON);
            String jsonPayload;
            logger.info("API Gateway URL: " + apiGatewayUrl);
            jsonPayload = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
            jsonPayload = jsonPayload.replace("REPLACE_WITH_API_GATEWAY_URL", apiGatewayUrl + "products");
            logger.info("Webhook payload: {}", jsonPayload);
            restTemplate.postForObject(url, jsonPayload, String.class);
        } catch (IOException exception) {
            logger.error("Failed to send webhook request: {}", exception.getMessage(), exception);
        }
    }

    /**
     * Checks if the current profile is a dev profile.
     *
     * @return true if the current profile is a dev profile, false otherwise.
     */
    private boolean isDevProfile() {
        if (env == null) {
            return true;
        }
        String[] activeProfiles = env.getActiveProfiles();
        return activeProfiles.length > 0 && activeProfiles[0].equals(DEV);
    }

}
