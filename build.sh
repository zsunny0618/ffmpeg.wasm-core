#!/bin/bash -x

set -eo pipefail

ROOT=$(dirname $0)

# verify Emscripten version
emcc -v
# configure FFmpeg with Emscripten
$ROOT/wasm/build-scripts/configure.sh
# build dependencies
$ROOT/wasm/build-scripts/make.sh
# build ffmpeg.wasm
$ROOT/wasm/build-scripts/build-ffmpeg.sh
