
#LOCAL
# # Use the Open Liberty image as the base
# FROM open-liberty:24.0.0.12-full-java17-openj9


# # Copy the Spring Boot application JAR to the container
# COPY build/libs/demo-0.0.1-SNAPSHOT.jar /config/apps/

# # Copy Open Liberty server.xml configuration
# COPY src/main/liberty/config/server.xml /config/

# # Enable required Liberty features
# RUN /opt/ol/wlp/bin/server featureManager install --acceptLicense --features springBoot-3.0

# # Expose ports for HTTP and HTTPS
# EXPOSE 9080 9443

# # Default command to start Open Liberty
# CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]

#END LOCAL


# Stage 1: Build the Spring Boot JAR using Gradle
FROM gradle:7.6-jdk17 AS build

# Set working directory
WORKDIR /app

# Copy the Gradle wrapper and Gradle files
COPY gradlew gradlew.bat /app/
COPY gradle /app/gradle
COPY build.gradle /app/
COPY settings.gradle /app/

# Copy the rest of the application code
COPY src /app/src

# Run Gradle to build the Spring Boot JAR (bootJar task)
RUN ./gradlew bootJar

# Stage 2: Use Open Liberty as the base image for the runtime environment
FROM open-liberty:24.0.0.12-full-java17-openj9

# Copy the built Spring Boot application JAR from the build stage
COPY --from=build /app/build/libs/demo-0.0.1-SNAPSHOT.jar /config/apps/

# Copy Open Liberty server.xml configuration
COPY src/main/liberty/config/server.xml /config/

# Enable required Liberty features
RUN /opt/ol/wlp/bin/installUtility install springBoot-3.0 mpHealth-3.1

# Expose ports for HTTP and HTTPS
EXPOSE 9080 9443

# Default command to start Open Liberty
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]
