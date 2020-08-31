#!/bin/bash -x

# verify Emscripten version
emcc -v

# configure FFmpeg with Emscripten
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

# build FFmpeg.wasm

emmake make -j
