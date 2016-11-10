#!/bin/bash
set -e
JENKINS_NAME=${JENKINS_NAME:-jenkins}
JENKINS_VOLUME=${JENKINS_VOLUME:-jenkins-volume}
JENKINS_IMAGE_NAME=${JENKINS_IMAGE_NAME:-jenkins-v2}
JENKINS_OPTS=${JENKINS_OPTS:---prefix=/jenkins}
TIMEZONE=${TIMEZONE:-Asia/Shanghai}

# Create Jenkins volume.
if [ -z "$(docker ps -a | grep ${JENKINS_VOLUME})" ]; then
    docker run \
    --name ${JENKINS_VOLUME} \
    --entrypoint="echo" \
    ${JENKINS_IMAGE_NAME} \
    "Create Jenkins volume."
fi

# Start Jenkins.
docker run \
--name ${JENKINS_NAME} \
-p 50000:50000 \
--volumes-from ${JENKINS_VOLUME} \
-e JAVA_OPTS="-Duser.timezone=${TIMEZONE} -Djenkins.install.runSetupWizard=false" \
--restart=unless-stopped \
-d ${JENKINS_IMAGE_NAME} ${JENKINS_OPTS}
