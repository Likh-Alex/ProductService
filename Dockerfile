FROM eclipse-temurin:17-jdk-alpine
LABEL authors="sasha"
WORKDIR /app

# Copy the jar
COPY target/ProductService-0.0.1-SNAPSHOT.jar /app/ProductService-0.0.1-SNAPSHOT.jar
EXPOSE 8080
CMD ["java", "-jar", "ProductService-0.0.1-SNAPSHOT.jar"]