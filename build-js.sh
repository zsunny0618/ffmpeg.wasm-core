#!/bin/bash -x

configure_js() {
  emconfigure ./configure \
    --disable-x86asm \
    --disable-inline-asm \
    --disable-doc \
    --disable-stripping \
    --nm="llvm-nm -g" \
    --ar=emar \
    --cc=emcc \
    --cxx=em++ \
    --objcc=emcc \
    --dep-cc=emcc
}

make_js() {
  NPROC=$(grep -c ^processor /proc/cpuinfo)
  emmake make -j${NPROC}
}

build_js() {
  emcc \
    -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample \
    -Qunused-arguments \
    -o ffmpeg.js fftools/ffmpeg_opt.o fftools/ffmpeg_filter.o fftools/ffmpeg_hw.o fftools/cmdutils.o fftools/ffmpeg.o \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm -pthread \
    -s TOTAL_MEMORY=33554432
}

main() {
  configure_js
  make_js
  build_js
}

main "$@"
