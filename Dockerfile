
# ---------- Stage 1: Build WAR ----------
#FROM maven:3.8.5-openjdk-17 AS builder
FROM maven AS builder
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run in Tomcat ----------
# FROM tomcat:9.0
FROM tomcat
# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from build stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
    