#FROM eclipse-temurin:17-jre-jammy
FROM alpine:3.18.2

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 10 jdk 17 root less"

RUN apk update
RUN apk add openjdk17-jre-headless
RUN apk cache clean

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat
USER tomcat

# download tomcat 10
RUN wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.11/bin/apache-tomcat-10.1.11.zip -P /home/tomcat/
RUN unzip /home/tomcat/apache-tomcat-10.1.11.zip -d /home/tomcat/
RUN rm /home/tomcat/apache-tomcat-10.1.11.zip
RUN mv /home/tomcat/apache-tomcat-10.1.11 /home/tomcat/apache-tomcat

# remove all default webapps
RUN rm -rf /home/tomcat/apache-tomcat/webapps/*

RUN chmod +x /home/tomcat/apache-tomcat/bin/*.sh
RUN export CATALINA_BASE=/home/tomcat/apache-tomcat
RUN export CATALINA_HOME=/home/tomcat/apache-tomcat

EXPOSE 8080:8080

CMD /home/tomcat/apache-tomcat/bin/catalina.sh start && tail -f /home/tomcat/apache-tomcat/logs/catalina.out