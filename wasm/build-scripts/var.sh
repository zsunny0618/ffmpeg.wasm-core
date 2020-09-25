#!/bin/bash
#
# Common variables for all scripts

set -euo pipefail

# Flags for code optimization, focus on speed instead
# of size
OPTIM_FLAGS=(
  -O3
)

# Directory to install headers and libraries
BUILD_DIR=build

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Use closure complier only in linux environment
  OPTIM_FLAGS=(
    "${OPTIM_FLAGS[@]}"
    --closure 1
  )
fi

# Convert array to string
OPTIM_FLAGS="${OPTIM_FLAGS[@]}"

echo "OPTIM_FLAGS=$OPTIM_FLAGS"
echo "BUILD_DIR=$BUILD_DIR"
