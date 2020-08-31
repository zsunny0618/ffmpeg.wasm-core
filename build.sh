#!/bin/bash -x

# verify Emscripten version
emcc -v

# configure FFmpeg with Emscripten
FLAGS=(
  --disable-x86asm
  --disable-inline-asm    #Disable inline asm
  --disable-doc           #Disable document generation
  --nm="llvm-nm -g"
  --ar=emar
  --as=llvm-as
  --ranlib=llvm-ranlib
  --cc=emcc
  --cxx=em++
  --objcc=emcc
  --dep-cc=emcc
)
emconfigure ./configure "${FLAGS[@]}"

# build FFmpeg.wasm
emmake make -j
