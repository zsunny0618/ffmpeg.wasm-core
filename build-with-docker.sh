#!/bin/bash -x

docker pull gcc:8
docker run \
  -v $PWD:/usr/src \
  gcc:8 \
  sh -c 'cd /usr/src && bash ./build.sh'
