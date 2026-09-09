FROM eclipse-temurin:21-jre
WORKDIR /app
COPY build/libs/board-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]