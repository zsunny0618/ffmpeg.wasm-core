#!/bin/bash -x

# verify Emscripten version
emcc -v

# configure FFMpeg with Emscripten
emconfigure ./configure \
  --disable-x86asm \
  --nm="llvm-nm -g" \
  --ar=emar \
  --as=llvm-as \
  --ranlib=llvm-ranlib \
  --cc=emcc \
  --cxx=em++ \
  --objcc=emcc \
  --dep-cc=emcc
