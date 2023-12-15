package com.example.ProductService;

import org.axonframework.config.EventProcessingConfigurer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class ProductServiceApplicationTest {

	@Mock
	private EventProcessingConfigurer configurer;

	@Test
	void shouldConfigureEventProcessing() {
		ProductServiceApplication application = new ProductServiceApplication();
		application.configure(configurer);

		verify(configurer).registerListenerInvocationErrorHandler(eq("product"), any());
	}
}
