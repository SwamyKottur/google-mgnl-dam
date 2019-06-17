#!/bin/bash

# Cleanup all pre-existing images, containers, volumes or networks
docker ps --filter "name=server" -q |xargs docker rm --force
docker images --filter "label=google-mgnl" -q |xargs docker rmi --force
# docker system prune --all --volumes --force
docker network ls --filter "name=google-storage-mgnl" -q |xargs docker network rm

# Create out of the two war files in magnolia-integration-tests/tests/target/wars a docker container
docker build --no-cache -t google-mgnl/storage-module-ee:latest --label google-mgnl .

# Create custom network for test containers to use
docker network create google-storage-mgnl

# Startup all containers
docker run --name=server --network=google-storage-mgnl -d -p 8080:8080 google-mgnl/storage-module-ee:latest
# docker run --network google-storage-mgnl -d -p 4444:4444 --name selenium-hub selenium/hub:3.7.1-beryllium
# docker run -d --network google-storage-mgnl -e HUB_PORT_4444_TCP_ADDR=selenium-hub -p 5901:5900 -e HUB_PORT_4444_TCP_PORT=4444 selenium/node-chrome-debug:3.7.1-beryllium