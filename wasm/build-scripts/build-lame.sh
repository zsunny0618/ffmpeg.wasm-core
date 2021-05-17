#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/lame
CFLAGS="-s USE_PTHREADS=1 $OPTIM_FLAGS"
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-linux                                   # use i686 linux
  --disable-shared                                    # disable shared library
  --disable-frontend                                  # exclude lame executable
  --disable-analyzer-hooks                            # exclude analyzer hooks
  --disable-dependency-tracking                       # speed up one-time build
  --disable-gtktest
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && CFLAGS=$CFLAGS emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH install -j
emmake make -C $LIB_PATH clean
