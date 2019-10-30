#!/bin/bash -x

set -e -o pipefail

BUILD_DIR=$PWD/build

build_x264() {
  cd third_party/x264
  emconfigure ./configure \
    --disable-asm \
    --disable-thread \
    --prefix=$BUILD_DIR
  emmake make install-lib-static
  cd -
}

configure_ffmpeg() {
  emconfigure ./configure \
    --enable-gpl \
    --enable-libx264 \
    --disable-pthreads \
    --disable-x86asm \
    --disable-inline-asm \
    --disable-doc \
    --disable-stripping \
    --disable-ffprobe \
    --disable-ffplay \
    --prefix=$BUILD_DIR \
    --extra-cflags="-I$BUILD_DIR/include" \
    --extra-cxxflags="-I$BUILD_DIR/include" \
    --extra-ldflags="-L$BUILD_DIR/lib" \
    --nm="llvm-nm -g" \
    --ar=emar \
    --cc=emcc \
    --cxx=em++ \
    --objcc=emcc \
    --dep-cc=emcc
}

make_ffmpeg() {
  NPROC=$(grep -c ^processor /proc/cpuinfo)
  emmake make -j${NPROC}
}

build_ffmpegjs() {
  emcc \
    -I$BUILD_DIR/include \
    -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -Llibpostproc -L${BUILD_DIR}/lib \
    -Qunused-arguments -Oz \
    -o javascript/ffmpeg-core.js fftools/ffmpeg_opt.o fftools/ffmpeg_filter.o fftools/ffmpeg_hw.o fftools/cmdutils.o fftools/ffmpeg.o \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 \
    --closure 1 \
    -s USE_SDL=2 \
    -s MODULARIZE=1 \
    -s SINGLE_FILE=1 \
    -s EXPORTED_FUNCTIONS="[_ffmpeg]" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[cwrap, FS, getValue, setValue]" \
    -s TOTAL_MEMORY=33554432 \
    -s ALLOW_MEMORY_GROWTH=1
}

main() {
  build_x264
  configure_ffmpeg
  make_ffmpeg
  build_ffmpegjs
}

main "$@"
