#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/x265/source
CONF_FLAGS=(
  -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
  -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE
  -DENABLE_SHARED:bool=off
  -DENABLE_CLI:bool=off
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
rm -rf $LIB_PATH/build
mkdir -p $LIB_PATH/build
(cd $LIB_PATH/build && emmake cmake .. "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH/build clean
emmake make -C $LIB_PATH/build install -j
