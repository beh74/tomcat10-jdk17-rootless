FROM alpine:3.20

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 10 jdk 21 root less"

# DEFAULT MAJOR TOMCAT VERSION 
ARG TOMCAT_MAJOR_VERSION=10

# Upgrade Alpine packages, Install openjdk 21 
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk21-jre-headless wget unzip && \
    apk cache clean && rm -rf /var/cache/apk/*

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat

# Install latest tomcat 10 
RUN TOMCAT_VERSION=$(wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/ | \
        grep -o "v${TOMCAT_MAJOR_VERSION}\.[0-9]\+\.[0-9]\+" | \
        sort -V | tail -n 1) && \
    wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION/v/}.zip -P /home/tomcat/ && \
    unzip /home/tomcat/apache-tomcat-${TOMCAT_VERSION/v/}.zip -d /home/tomcat/ && \
    rm /home/tomcat/apache-tomcat-${TOMCAT_VERSION/v/}.zip && \
    mv /home/tomcat/apache-tomcat-${TOMCAT_VERSION/v/} /home/tomcat/apache-tomcat && \
    rm -rf /home/tomcat/apache-tomcat/webapps/* && \
    chmod +x /home/tomcat/apache-tomcat/bin/*.sh && \
    chown -R tomcat:tomcat /home/tomcat/*

# Set CATALINA_BASE and CATALINA_HOME environment variables
ENV CATALINA_BASE=/home/tomcat/apache-tomcat
ENV CATALINA_HOME=/home/tomcat/apache-tomcat

# Expose port 8080
EXPOSE 8080

# Default tomcat user 
USER tomcat

# run tomcat 
CMD ["/home/tomcat/apache-tomcat/bin/catalina.sh", "run"]
