#!/bin/bash -x

EM_VERSION=1.39.18-upstream
FLAGS=""
# Attach TTY only when available, this is for running in Gihub Actions
if [ -t 1 ]; then FLAGS="-it"; fi

docker pull trzeci/emscripten:$EM_VERSION
docker run $FLAGS \
  -v $PWD:/src \
  trzeci/emscripten:$EM_VERSION \
  sh -c 'bash ./build.sh'
