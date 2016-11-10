FROM jenkins:2.19.2

# Install docker
USER root
RUN curl -sSL https://get.docker.com/ | sh
ADD trusted-ca.list /etc/ssl/certs/ca-certificates.crt

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

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
  docker-commons \
  docker-workflow \
  git \
  maven-plugin \
  parameterized-trigger \
  workflow-aggregator

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Add setup script.
COPY jenkins-setup.sh /usr/local/bin/jenkins-setup.sh

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh
COPY entrypoint.sh /entrypoint.sh

# Start docker and jenkins
USER root
ENTRYPOINT ["wrapdocker", "/entrypoint.sh"]
