#!/bin/bash -x

set -eo pipefail

ROOT=$1
BUILD_DIR=$2

OPT_FLAGS="-O3 --closure 1"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # As closure compiler requires java 6 and
  # I don't find a way to install it in github actions
  OPT_FLAGS="-O3"
fi

cd $ROOT
ARGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                                     # use i686 linux
  --enable-static                                     # enable building static library
  --disable-cli                                       # disable cli tools
  --disable-asm                                       # disable asm optimization
  --extra-cflags="-s USE_PTHREADS=1 $OPT_FLAGS"  # flags to use pthread and code optimization
)
emconfigure ./configure "${ARGS[@]}"
emmake make install-lib-static -j4
cd -
