# step 1: run sonarqube scan
FROM sonarsource/sonar-scanner-cli AS sonarqube
WORKDIR /usr/src/app
COPY . .
RUN sonar-scanner \
    -Dsonar.projectKey=spring-petclinic \
    -Dsonar.sources=. \
    -Dsonar.host.url=http://localhost:9000 \
    -Dsonar.login=squ_06a14b02bb8dc1ecb786691e0d8ee402d5c25014

# step 2: build with maven using java 17
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /build
COPY . .
RUN ./mvnw clean package

# step 3: create the final image with java 17
FROM openjdk:17-jdk-slim
WORKDIR /code
COPY --from=builder /build/target/spring-petclinic-3.3.0-SNAPSHOT.jar /code/
CMD ["java", "-jar", "/code/spring-petclinic-3.3.0-SNAPSHOT.jar"]
