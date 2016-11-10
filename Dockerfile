FROM jenkins:2.19.2

# Install docker
USER root
ENV DOCKER_VERSION 1.12.3
RUN curl -fsSLo d.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && tar --strip-components=1 -xvzf d.tgz -C /usr/local/bin && rm d.tgz

# Install rancher-compose
ENV RANCHER_COMPOSE_VERSION v0.8.6
RUN curl -fsSLo r.tgz https://releases.rancher.com/compose/${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz && tar --strip-components=2 -xvzf r.tgz -C /usr/local/bin && rm r.tgz

# Install maven
ENV MAVEN_VERSION 3.3.9
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin:/var/maven/bin
RUN curl -fsSLo m.tgz http://apache.fayea.com/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && tar -xvzf m.tgz && mv apache-maven-${MAVEN_VERSION} /var/maven && rm m.tgz

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
