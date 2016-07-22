# docker-eap-angular 

DIY Docker container running EAP with the Angular Kitchensink app available at: https://github.com/jboss-developer/jboss-eap-quickstarts/tree/7.1.x-develop/kitchensink-angularjs

This repo contains the prebuild war from kitchesink sink, but if you want to build it yourself just clone it locally then:
1. In the pom.xml change the jboss.bom.eap version to 7.0.0.GA
2. Run mvn clean package


Prerequisites
-----------------------------

1. Since for legal reasons, I cannot add the JBoss EAP binaries to this application, you need to download JBoss EAP 6.4 from either of the following locations:
For Red Hat Customers:
https://access.redhat.com/jbossnetwork/restricted/softwareDetail.html?softwareId=37393&product=appplatform&version=6.4&downloadType=distributions
For Non Red Hat Customers:
http://developers.redhat.com/products/eap/download/ 

This Docker file is based around EAP 6.4 although EAP 7 has been tested and works well. To use EAP 7 just update the ARG parameters in the Dockefile or pass the build-arguments for your instance

2. You also need to add RHN_USER and RHN_PASSWORD ARGs to the Dockerfile so that the RHEL7 image can subscribe to subscription manager

Build and Deploy locally
-----------------------------

1. Open a command prompt and navigate to the this locally cloned github repo.
2. Type this command to build the docker image: 
        docker build -t=johnfosborneiii/rhel7-eap-angular . 
 
3. Type this command to run the docker image: 
        docker run -it -p 8080:8080 johnfosborneiii/rhel7-eap-angular
 
4. The application will be running at the following URL: <http://localhost:8080/jboss-kitchensink-angularjs/>
