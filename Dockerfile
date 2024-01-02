FROM alpine:3.10
LABEL authors="sasha"
WORKDIR /app

# Copy the jar
COPY target/ProductService-0.0.1-SNAPSHOT.jar /app/ProductService-0.0.1-SNAPSHOT.jar
EXPOSE 8081
CMD ["java", "-jar", "ProductService-0.0.1-SNAPSHOT.jar"]