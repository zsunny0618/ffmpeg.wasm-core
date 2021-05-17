#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/libass
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                                     # use i686 linux
  --disable-shared
  --enable-static
  --disable-asm                                       # disable asm optimization
  --disable-fontconfig
  --disable-require-system-font-provider
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && ./autogen.sh && EM_PKG_CONFIG_PATH=$EM_PKG_CONFIG_PATH emconfigure ./configure -C "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH install -j
emmake make -C $LIB_PATH clean
