# This docker file is based on the latest version of RHEL7. It performs the following:
# 1. Updates the image
# 2. Downloads and unzips EAP 6.4
# 3. Deploys a prebuilt AngularJS WAR
# 4. Runs JBoss EAP

# Use this command line to build and run:
# docker build -t="rhel7-eap-angular" . 
# docker run rhel7-eap-angular
#
# Build Arguments:
#
# RHN_USER - The Red Hat Network user name used to register the container
# RHN_PASSWORD - The Red Hat Network user password

FROM registry.access.redhat.com/rhel7:latest
MAINTAINER John Osborne "josborne@redhat.com"

ARG EAP_VERSION=6.4.0
ARG JBOSS_HOME=jboss-eap-6.4
#ARG RHN_USER yourusernamehere 
#ARG RHN_PASSWORD yourpasswordhere
ARG WORKDIR=/home/jboss

#RUN subscription-manager register --username ${RHN_USER} --password ${RHN_PASSWORD} --auto-attach && \
#	subscription-manager repos --enable rhel-server-rhscl-7-rpms

RUN yum -y install yum-utils
RUN yum install yum-utils -y && yum clean all
RUN yum-config-manager --enable rhel-6-server-rpms rhel-server-rhscl-7-rpms rhel-6-server-supplementary-rpms &> /dev/null
RUN yum repolist
#RUN yum --disablerepo=* repolist && \
#    yum-config-manager --disable \* &> /dev/null && \
#    yum-config-manager --enable rhel-6-server-rpms \
#                       --enable jb-eap-6-for-rhel-6-server-rpms \
#                       --enable rhel-6-server-rhevm-3.6-rpms \
#                       --enable rhel-6-server-supplementary-rpms
#                         &> /dev/null

RUN yum -y install java-1.8.0-openjdk-devel wget unzip \
  	yum -y update \
    yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "JBoss user" jboss

# Set the working directory to jboss' user home directory
WORKDIR ${WORKDIR} 

# Copy the files I need
COPY resources/jboss-eap-${EAP_VERSION}.zip .
COPY resources/jboss-kitchensink-angularjs.war .

#Set the ownership and permissions of the directory
RUN chmod 755 ${WORKDIR} 
RUN chown jboss:jboss -R ${WORKDIR} 

# Specify the user which should be used to execute all commands below
USER jboss

RUN unzip jboss-eap-${EAP_VERSION}.zip
RUN rm -f jboss-eap-${EAP_VERSION}.zip
RUN mv jboss-kitchensink-angularjs.war ${WORKDIR}/${JBOSS_HOME}/standalone/deployments/

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV JBOSS_HOME ${WORKDIR}/$JBOSS_HOME

EXPOSE 8080
ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0
