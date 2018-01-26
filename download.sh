#!/bin/bash

JENKINS_VERSION=1.609.2
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

curl -fsSL ${JENKINS_URL} -o jenkins-${JENKINS_VERSION}.war
echo "${JENKINS_SHA}  jenkins-${JENKINS_VERSION}.war" | sha256sum -c -
