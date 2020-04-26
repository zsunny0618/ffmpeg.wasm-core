#!/bin/bash
#
# This script is specific for building tesseract.js
# 
# Before running this script, you need to install docker first.
#

EMSCRIPTEN_VERSION=1.39.0
TTY=${1:-yes}

check_command() {
  CMD=$1
  command -v $CMD >/dev/null 2>&1 || { echo >&2 "$CMD is not installed  Aborting."; exit 1; }
}

build() {
  if [ "$TTY" = "no" ]; then
    docker run \
      --rm \
      -v ${PWD}:/src \
      trzeci/emscripten:${EMSCRIPTEN_VERSION} \
      sh -c "bash ./build-js.sh"
  else
    docker run -it \
      --rm \
      -v ${PWD}:/src \
      trzeci/emscripten:${EMSCRIPTEN_VERSION} \
      sh -c "bash ./build-js.sh"
  fi
}

main() {
  check_command docker
  build
}

main "$@"
