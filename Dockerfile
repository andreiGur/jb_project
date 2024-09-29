# step 1: run Sonarqube scan
FROM sonarsource/sonar-scanner-cli AS sonarqube
WORKDIR /usr/src/app
COPY . .

# Update this section to include SonarQube host and login details dynamically via build arguments if needed
ARG SONAR_HOST_URL=http://localhost:9000
ARG SONAR_LOGIN_TOKEN=squ_06a14b02bb8dc1ecb786691e0d8ee402d5c25014

RUN sonar-scanner \
    -Dsonar.projectKey=spring-petclinic \
    -Dsonar.sources=. \
    -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.login=${SONAR_LOGIN_TOKEN}

# step 2: build with Maven using Java 17
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /build

# Copy only pom.xml first to leverage Docker layer caching
COPY pom.xml .

# Download dependencies first to cache them
RUN mvn dependency:go-offline -B

# Now copy the rest of the source code and build the project
COPY . .
RUN ./mvnw clean package -DskipTests

# step 3: create the final image with Java 17
FROM openjdk:17-jdk-slim
WORKDIR /code

# Copy the generated JAR from the builder stage
COPY --from=builder /build/target/spring-petclinic-3.3.0-SNAPSHOT.jar /code/

# Run the Spring Boot application
CMD ["java", "-jar", "/code/spring-petclinic-3.3.0-SNAPSHOT.jar"]
