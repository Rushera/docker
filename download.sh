#!/bin/bash

JENKINS_VERSION=1.609.2
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
JENKINS_SHA=59215da16f9f8a781d185dde683c05fcf11450ef

curl -fsSL ${JENKINS_URL} -o jenkins-${JENKINS_VERSION}.war
echo "${JENKINS_SHA}  jenkins-${JENKINS_VERSION}.war" | sha1sum -c -
