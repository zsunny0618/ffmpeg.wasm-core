#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

FLAGS=(
  "${FFMPEG_CONFIG_FLAGS_BASE[@]}"
)
echo "FFMPEG_CONFIG_FLAGS=${FLAGS[@]}"
emconfigure ./configure "${FLAGS[@]}"
