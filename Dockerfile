FROM jenkins:2.19.2

# Install docker
USER root
ENV DOCKER_VERSION 1.12.3
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin

# Install rancher-compose
ENV RANCHER_COMPOSE_VERSION v0.8.6
RUN curl -fsSLO https://releases.rancher.com/compose/${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz && tar zxf rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz

# Install plugins
USER jenkins
RUN /usr/local/bin/install-plugins.sh \
  docker-build-publish \
  git \
  maven-plugin \
  parameterized-trigger \
  swarm

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Add setup script.
COPY jenkins-setup.sh /usr/local/bin/jenkins-setup.sh

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
