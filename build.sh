#!/bin/bash -x

# verify Emscripten version
emcc -v

# configure FFMpeg with Emscripten
emconfigure ./configure \
  --disable-x86asm
