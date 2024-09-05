# Use the official OpenJDK image from the Docker Hub
FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file into the container
COPY MyFristDemoWithSpring/target/MyFristDemoWithSpring-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port that the application runs on
EXPOSE 8080

# Define the command to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
