#!/bin/bash

set -euo pipefail

EM_VERSION=1.39.18-upstream

docker pull trzeci/emscripten:$EM_VERSION
docker run \
  --rm \
  -v $PWD:/src \
  -v $PWD/wasm/cache:/emsdk_portable/.data/cache/wasm \
  trzeci/emscripten:$EM_VERSION \
  sh -c 'bash ./build.sh'
