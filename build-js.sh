#!/bin/bash -x

set -e -o pipefail

NPROC=$(grep -c ^processor /proc/cpuinfo)
BUILD_DIR=$PWD/build

install_deps() {
  apt-get update
  apt-get install -y autoconf libtool
}

build_libwavpack() {
  cd third_party/WavPack
  emconfigure ./autogen.sh \
    --disable-asm \
    --prefix=$BUILD_DIR
  emmake make install -j${NPROC}
  cd -
}

build_libfdk_aac() {
  cd third_party/fdk-aac
  ./autogen.sh
  emconfigure ./configure --prefix=$BUILD_DIR
  emmake make install -j${NPROC}
  cd -
}

build_libmp3lame() {
  cd third_party/lame
  emconfigure ./configure --prefix=$BUILD_DIR
  emmake make install -j${NPROC}
  cd -
}

configure_ffmpeg() {
  emconfigure ./configure \
    --disable-x86asm \
    --disable-inline-asm \
    --disable-doc \
    --disable-stripping \
    --disable-ffprobe \
    --disable-ffmpeg \
    --enable-libmp3lame \
    --enable-libfdk-aac \
    --prefix=$BUILD_DIR \
    --extra-cflags=-I$BUILD_DIR/include \
    --extra-ldflags=-L$BUILD_DIR/lib \
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
    -I. -I$BUILD_DIR/include \
    -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -L$BUILD_DIR/lib \
    -Qunused-arguments \
    -o javascript/ffmpeg-core.js libffmpeg/transcoding.c \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lm -lmp3lame -lfdk-aac \
    -s MODULARIZE=1 \
    -s EXPORTED_FUNCTIONS="[_av_log_set_level, _transcoding]" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[cwrap, FS, getValue, setValue]" \
    -s TOTAL_MEMORY=33554432 \
    -s ALLOW_MEMORY_GROWTH=1
}

main() {
  install_deps
  build_libwavpack
  build_libfdk_aac
  build_libmp3lame
  configure_ffmpeg
  make_ffmpeg
  build_ffmpegjs
}

main "$@"
