FROM openjdk:7-jdk-alpine

# Install fonts in case of FontManager error
RUN apk update && apk add --no-cache wget git curl zip font-adobe-100dpi ttf-dejavu fontconfig

ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/vloume from a data container, 
# ensure you use same uid
RUN addgroup jenkins && adduser -h "$JENKINS_HOME" -u 1000 -G jenkins -s /bin/bash -S jenkins

# Jenkins home directoy is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d


COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ENV JENKINS_VERSION 1.609.2
ENV JENKINS_SHA 59215da16f9f8a781d185dde683c05fcf11450ef

COPY jenkins-$JENKINS_VERSION.war /usr/share/jenkins/jenkins.war
RUN echo "$JENKINS_SHA  /usr/share/jenkins/jenkins.war" | sha1sum -c -

ENV JENKINS_UC https://updates.jenkins-ci.org
ENV JENKINS_UC_DOWNLOAD $JENKINS_UC/download
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG /var/log/copy_reference_file.log
RUN touch $COPY_REFERENCE_FILE_LOG && chown jenkins.jenkins $COPY_REFERENCE_FILE_LOG

USER jenkins

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugin.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
