############################################################
# Dockerfile to run Apache usergrid_
# Based on Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM ubuntu

MAINTAINER Gabor Wnuk <gabor.wnuk@me.com>

ENV TOMCAT_CONFIGURATION_FLAG /usergrid/.tomcat_admin_created
ENV CATALINA_BASE /etc/tomcat7
ENV CATALINA_TMPDIR /tmp

RUN mkdir /usergrid
WORKDIR /usergrid

# Update the default application repository sources list
RUN apt-get update

# Install maven (specifically 3.0.5)
RUN apt-get install -y maven=3.0.5-1 wget pwgen openjdk-7-jdk tomcat7

#
# Download, unpack and build usergrid_
#
RUN wget https://github.com/apache/incubator-usergrid/archive/portal-2.0.16.tar.gz -O portal.tar.gz
RUN tar zxvf portal.tar.gz
RUN cd incubator-usergrid-portal-*/stack; mvn clean install -DskipTests=true

#
# Configure basic stuff, nothing important.
#
ADD create_tomcat_admin_user.sh /usergrid/create_tomcat_admin_user.sh
ADD run.sh /usergrid/run.sh
RUN chmod +x /usergrid/*.sh
RUN ln -s /etc/tomcat7/ /etc/tomcat7/conf

#
# IMPORTANT: You may need to customise this file to suit Your needs before use.
#
ADD usergrid-deployment.properties /usr/share/tomcat7/lib/usergrid-deployment.properties

#
# Just to suppress tomcat warnings.
#
RUN mkdir -p /usr/share/tomcat7/common/classes
RUN mkdir -p /usr/share/tomcat7/server/classes
RUN mkdir -p /usr/share/tomcat7/shared/classes
RUN mkdir -p /usr/share/tomcat7/webapps

#
# Deploy WAR
#
RUN cp -f /usergrid/incubator-usergrid-portal-*/stack/rest/target/ROOT.war /usr/share/tomcat7/webapps/

RUN ln -s /usr/share/tomcat7/webapps/ /etc/tomcat7/webapps

#
# Port to expose (default for tomcat: 8080)
#
EXPOSE 8080

ENTRYPOINT ./run.sh
