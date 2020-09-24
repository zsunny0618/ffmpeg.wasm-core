#!/bin/bash -x

set -eo pipefail

BUILD_DIR=$1
CFLAGS="-s USE_PTHREADS -I$BUILD_DIR/include -O3 --closure 1"
LDFLAGS="$CFLAGS -L$BUILD_DIR/lib"
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
  --disable-debug         # disable debug info, required by closure
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
