#!/bin/bash -x

set -eo pipefail

ROOT=$1
BUILD_DIR=$2

cd $ROOT
ARGS=(
  --prefix=$BUILD_DIR                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                     # use i686 linux
  --enable-static                     # enable building static library
  --disable-cli                       # disable cli tools
  --disable-asm                       # disable asm optimization
  --extra-cflags="-s USE_PTHREADS=1"  # pass this flags for using pthreads
)
emconfigure ./configure "${ARGS[@]}"
emmake make install-lib-static -j4
cd -
