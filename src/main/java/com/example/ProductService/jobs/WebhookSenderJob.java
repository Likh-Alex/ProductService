package com.example.ProductService.jobs;

import com.example.ProductService.webhook.WebhookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class WebhookSenderJob {

    WebhookService webhookService;
    @Autowired
    Environment env;

    WebhookSenderJob(WebhookService webhookService) {
        this.webhookService = webhookService;
    }

    @Scheduled(fixedRate = 10000) // 10 seconds
    public void sendWebhook() {
        if (isDevProfile()) {
            return;
        }
        webhookService.setWebhook();
    }

    /**
     * Checks if the current profile is the development profile.
     *
     * @return true if the current profile is the development profile, false otherwise
     */
    private boolean isDevProfile() {
        if (env == null) {
            return true;
        }
        String[] activeProfiles = env.getActiveProfiles();
        return activeProfiles.length > 0 && activeProfiles[0].equals("dev");
    }
}