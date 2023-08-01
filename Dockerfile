FROM openjdk:8-jdk-alpine
WORKDIR /opt/app
COPY target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
