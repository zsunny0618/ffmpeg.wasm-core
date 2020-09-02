#!/bin/bash -x

set -eo pipefail

BUILD_DIR=$1
CFLAGS="-s USE_PTHREADS -O3 -I$BUILD_DIR/include"
LDFLAGS="$CFLAGS -L$BUILD_DIR/lib -s INITIAL_MEMORY=33554432" # 33554432 bytes = 32 MB
ARGS=(
  --target-os=none        # use none to prevent any os specific configurations
  --arch=x86_32           # use x86_32 to achieve minimal architectural optimization
  --enable-cross-compile  # enable cross compile
  --disable-x86asm        # disable x86 asm
  --disable-inline-asm    # disable inline asm
  --disable-stripping     # disable stripping
  --disable-programs      # disable programs build (incl. ffplay, ffprobe & ffmpeg)
  --disable-doc           # disable doc
  --enable-gpl            # required by x264
  --enable-libx264        # enable x264
  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"
  --nm="llvm-nm -g"
  --ar=emar
  --as=llvm-as
  --ranlib=llvm-ranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
)
emconfigure ./configure "${ARGS[@]}"
