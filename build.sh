#!/bin/bash -x

set -eo pipefail

ROOT=$PWD
BUILD_DIR=$ROOT/build

# verify Emscripten version
emcc -v
# build x264
$ROOT/wasm/build-scripts/build-x264.sh $ROOT/third_party/x264 $BUILD_DIR
# configure FFmpeg with Emscripten
$ROOT/wasm/build-scripts/configure.sh $BUILD_DIR
# # build dependencies
$ROOT/wasm/build-scripts/make.sh
# # build ffmpeg.wasm
$ROOT/wasm/build-scripts/build-ffmpeg.sh $BUILD_DIR
