FROM alpine:3.19

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 10 jdk 17 root less"

# Upgrade Alpine packages
RUN apk update && apk upgrade

# install jdk17
RUN apk add --no-cache openjdk17-jre-headless
RUN apk cache clean

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat
USER tomcat

# download tomcat 10
RUN wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.zip -P /home/tomcat/ \
    && unzip /home/tomcat/apache-tomcat-10.1.18.zip -d /home/tomcat/ \
    && rm /home/tomcat/apache-tomcat-10.1.18.zip \
    && mv /home/tomcat/apache-tomcat-10.1.18 /home/tomcat/apache-tomcat

# remove all default webapps
RUN rm -rf /home/tomcat/apache-tomcat/webapps/*

# Set executable permissions for Tomcat scripts
RUN chmod +x /home/tomcat/apache-tomcat/bin/*.sh

# Set CATALINA_BASE and CATALINA_HOME environment variables
ENV CATALINA_BASE=/home/tomcat/apache-tomcat
ENV CATALINA_HOME=/home/tomcat/apache-tomcat

# Expose port 8080
EXPOSE 8080:8080

# Run Tomcat
CMD ["/home/tomcat/apache-tomcat/bin/catalina.sh", "run"]
