#!/bin/bash

set -eo pipefail

SCRIPT_ROOT=$(dirname $0)/wasm/build-scripts

# verify Emscripten version
emcc -v
# build x264
$SCRIPT_ROOT/build-x264.sh
# build libvpx
$SCRIPT_ROOT/build-libvpx.sh
# configure FFmpeg with Emscripten
$SCRIPT_ROOT/configure-ffmpeg.sh
# build ffmpeg.wasm
$SCRIPT_ROOT/build-ffmpeg.sh
