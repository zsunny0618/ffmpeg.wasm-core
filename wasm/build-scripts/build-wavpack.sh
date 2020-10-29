#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/WavPack
FLAGS="-s USE_PTHREADS=1 $OPTIM_FLAGS"
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                  # install library in a build directory for FFmpeg to include
  --host=x86-linux-gnu
  --disable-asm                                        # disable asm optimization
  --disable-man
  --disable-tests
  --disable-apps
  --disable-dsd
  --enable-legacy
  --disable-shared                                     # enable building static library
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && CFLAGS=$FLAGS emconfigure ./autogen.sh "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
