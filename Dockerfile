# Use the Open Liberty image as the base
FROM openliberty/open-liberty:kernel-java11-openj9

# Copy Open Liberty server.xml configuration
COPY src/main/liberty/config/server.xml /config/

# Copy the Spring Boot application JAR to the container
COPY build/libs/demo-0.0.1-SNAPSHOT.jar /config/apps

# Install necessary Liberty features
RUN features.sh install springBoot-3.0 mpHealth-3.1


# Expose ports for HTTP and HTTPS
EXPOSE 9080 9443

# Default command to start Open Liberty
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]