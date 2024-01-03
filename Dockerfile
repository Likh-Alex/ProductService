FROM eclipse-temurin:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENV SPRING_PROFILES_ACTIVE=prod
ENTRYPOINT ["java","-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}","-jar","/app.jar"]
