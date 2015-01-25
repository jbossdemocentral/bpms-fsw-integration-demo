# Use jbossdemocentral/developer as the base
FROM jbossdemocentral/developer

# Maintainer details
MAINTAINER Andrew Block <andy.block@gmail.com>

# Environment Variables 
ENV BPMS_HOME /opt/jboss/bpms
ENV BPMS_VERSION_MAJOR 6
ENV BPMS_VERSION_MINOR 0
ENV BPMS_VERSION_MICRO 3

ENV FSW_HOME /opt/jboss/fsw
ENV FSW_VERSION_MAJOR 6
ENV FSW_VERSION_MINOR 0
ENV FSW_VERSION_MICRO 0

# ADD Installation Files
COPY support/installation-bpms support/installation-bpms.variables support/installation-fsw support/installation-fsw.variables installs/jboss-bpms-installer-$BPMS_VERSION_MAJOR.$BPMS_VERSION_MINOR.$BPMS_VERSION_MICRO.GA-redhat-1.jar installs/jboss-fsw-installer-$FSW_VERSION_MAJOR.$FSW_VERSION_MINOR.$FSW_VERSION_MICRO.GA-redhat-4.jar  /opt/jboss/

# Configure project prerequisites and run installer and cleanup installation components
RUN mkdir -p /opt/jboss/projects /opt/jboss/support \
  && sed -i "s:<installpath>.*</installpath>:<installpath>$BPMS_HOME</installpath>:" /opt/jboss/installation-bpms \
  && java -jar /opt/jboss/jboss-bpms-installer-$BPMS_VERSION_MAJOR.$BPMS_VERSION_MINOR.$BPMS_VERSION_MICRO.GA-redhat-1.jar  /opt/jboss/installation-bpms -variablefile /opt/jboss/installation-bpms.variables \
  && rm -rf /opt/jboss/jboss-bpms-installer-$BPMS_VERSION_MAJOR.$BPMS_VERSION_MINOR.$BPMS_VERSION_MICRO.GA-redhat-1.jar /opt/jboss/installation-bpms /opt/jboss/installation-bpms.variables $BPMS_HOME/jboss-eap-6.1/standalone/configuration/standalone_xml_history/ \
  && sed -i "s:<installpath>.*</installpath>:<installpath>$FSW_HOME</installpath>:" /opt/jboss/installation-fsw \
  && java -jar /opt/jboss/jboss-fsw-installer-$FSW_VERSION_MAJOR.$FSW_VERSION_MINOR.$FSW_VERSION_MICRO.GA-redhat-4.jar  /opt/jboss/installation-fsw -variablefile /opt/jboss/installation-fsw.variables \
  && rm -rf /opt/jboss/jboss-fsw-installer-$FSW_VERSION_MAJOR.$FSW_VERSION_MINOR.$FSW_VERSION_MICRO.GA-redhat-4.jar /opt/jboss/installation-fsw /opt/jboss/installation-fsw.variables $FSW_HOME/jboss-eap-6.1/standalone/configuration/standalone_xml_history/ 

# Copy demo, support files and helper script
COPY projects /opt/jboss/projects
COPY support/bpm-suite-demo-niogit $BPMS_HOME/jboss-eap-6.1/bin/.niogit
COPY support/application-roles.properties support/standalone.xml $BPMS_HOME/jboss-eap-6.1/standalone/configuration/
COPY support/dtgov.properties $FSW_HOME/jboss-eap-6.1/standalone/configuration/
COPY support/dtgovwf-pom.xml $FSW_HOME/jboss-eap-6.1/dtgov-data/pom.xml
COPY support/overlord.demo.SimpleReleaseProcessBPMS.bpmn $FSW_HOME/jboss-eap-6.1/dtgov-data/src/main/resources/SRAMPPackage/
COPY support/overlord.demo.SimpleReleaseProcess.bpmn $FSW_HOME/jboss-eap-6.1/dtgov-data/src/main/resources/SRAMPPackage/
COPY support/sramp-dtgovwf-upload.txt /opt/jboss/support/
COPY support/docker/start.sh /opt/jboss/


# Swtich back to root user to perform build and cleanup
USER root

# Adjust permissions and cleanup
RUN sed -i "s:support/dtgov-workflows-1.0.2.Final-redhat-8.jar:/opt/jboss/support/dtgov-workflows-1.0.2.Final-redhat-8.jar:" /opt/jboss/support/sramp-dtgovwf-upload.txt \
  && chown -R jboss:jboss $FSW_HOME/jboss-eap-6.1/dtgov-data/ \
  && mvn -f $FSW_HOME/jboss-eap-6.1/dtgov-data/pom.xml package \
  && chown -R jboss:jboss /opt/jboss/support \
  && cp -v $FSW_HOME/jboss-eap-6.1/dtgov-data/target/dtgov-workflows-1.0.2.Final-redhat-8.jar /opt/jboss/support \
  && chown -R jboss:jboss $BPMS_HOME/jboss-eap-6.1/bin/.niogit $BPMS_HOME/jboss-eap-6.1/standalone/configuration/application-roles.properties $BPMS_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml $FSW_HOME/jboss-eap-6.1/standalone/configuration/standalone.xml /opt/jboss/projects/ /opt/jboss/start.sh \
  && ln -s $FSW_HOME/jboss-eap-6.1/standalone/deployments/ /tmp/prod \
  && chmod +x /opt/jboss/start.sh  

# Run as JBoss 
USER jboss

# Expose Ports
EXPOSE 9990 9999 8080 10090 10099 8180

# Default Command
CMD ["/bin/bash"]

# Helper script
ENTRYPOINT ["/opt/jboss/start.sh"]
