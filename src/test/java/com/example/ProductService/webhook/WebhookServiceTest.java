package com.example.ProductService.webhook;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

class WebhookServiceTest {
    
    @Test
    void testSendPostWebhook() {
        RestTemplate restTemplate = Mockito.mock(RestTemplate.class);
        ResourceLoader resourceLoader = Mockito.mock(ResourceLoader.class);
        Resource resource = Mockito.mock(Resource.class);
        when(resourceLoader.getResource(anyString())).thenReturn(resource);
        when(restTemplate.postForObject(anyString(), anyString(), eq(String.class))).thenReturn("");

        try {
            when(resource.getInputStream()).thenReturn(StreamUtils.emptyInput());
            WebhookService webhookService = new WebhookService(resourceLoader, restTemplate);
            webhookService.sendPostWebhook();
            Mockito.verify(restTemplate, Mockito.times(1)).postForObject(anyString(), anyString(), eq(String.class));
        } catch (IOException exception) {
            fail("Test failed due to an IOException: " + exception.getMessage());
        }
    }

}