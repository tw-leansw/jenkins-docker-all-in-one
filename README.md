# jenkins-docker-all-in-one

Jenkins v2 docker image with plugins, maven, git, docker, rancher-compose

Official Jenkins docker plus some plugins.

Installed tools:
- docker v1.12.3
- rancher-compose v0.8.6
- jdk v1.8.0_111
- maven v3.3.9

Additional plugins include:
-  docker-commons
-  docker-workflow
-  git
-  maven-plugin
-  parameterized-trigger
-  workflow-aggregator

Run it:
```
docker run -d -p 8080:8080 --name=jenkins-v2 flin/jenkins-v2-all-in-one:2.19.2
```
