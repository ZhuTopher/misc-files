#! /bin/sh

docker stop $(docker ps -aq)
docker rm $(docker container list -aq)
docker network prune
