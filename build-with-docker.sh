#!/bin/bash

EM_SDK_TAG=sdk-tag-1.38.32-64bit

docker pull trzeci/emscripten:$EM_SDK_TAG
docker run -it \
  -v $PWD:/src \
  trzeci/emscripten:$EM_SDK_TAG \
  bash build-js.sh
