#!/bin/bash -x

configure_js() {
  CC=emcc
  CXX=em++
  emconfigure ./configure \
    --target-os=none \
    --arch=x86_32 \
    --cpu=generic \
    --disable-everything \
    --disable-doc \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-inline-asm \
    --disable-x86asm \
    --disable-stripping \
    --disable-shared \
    --enable-static \
    --enable-cross-compile \
    --cc=$CC \
    --cxx=$CXX \
    --as=$CC \
    --ar=emar \
    --nm=llvm-nm
}

make_js() {
  NPROC=$(grep -c ^processor /proc/cpuinfo)
  emmake make -j${NPROC}
}

build_js() {
  LIBS="-Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample"
  FLAGS="-lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm -pthread -m"
  emcc \
    $LIBS \
    -Qunused-arguments \
    -o ffmpeg.js fftools/ffmpeg_opt.o fftools/ffmpeg_filter.o fftools/ffmpeg_hw.o fftools/cmdutils.o fftools/ffmpeg.o \
    $FLAGS
}

main() {
  #configure_js
  #make_js
  build_js
}

main "$@"
