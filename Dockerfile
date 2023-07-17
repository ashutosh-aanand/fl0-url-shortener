# Stage 1: Build the application
FROM gradle:jdk8 AS build
WORKDIR /app

# Copy the Gradle build files
COPY build.gradle .
COPY settings.gradle .
COPY gradlew .

# Copy the source code
COPY src ./src

# Build the application
RUN ./gradlew build

# Stage 2: Create the final image
FROM openjdk:8-jdk-alpine
VOLUME /tmp
EXPOSE 8080

# Copy the JAR file from the build stage to the final image
COPY --from=build /app/build/libs/*.jar app.jar

# Set the entrypoint to run the application
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]
