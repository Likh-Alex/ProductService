package com.example.ProductService.jobs;

import java.io.IOException;

import com.example.ProductService.webhook.WebhookService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class WebhookSenderJob {

    WebhookService webhookService;

    WebhookSenderJob(WebhookService webhookService) {
        this.webhookService = webhookService;
    }

    @Scheduled(fixedRate = 60000) // 1 minute
    public void sendWebhook() throws IOException {
        webhookService.setWebhook();
    }
}