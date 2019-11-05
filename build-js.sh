#!/bin/bash -x

set -e -o pipefail

NPROC=$(grep -c ^processor /proc/cpuinfo)
ROOT_DIR=$PWD
BUILD_DIR=$ROOT_DIR/build

build_x264() {
  cd third_party/x264
  emconfigure ./configure \
    --disable-asm \
    --disable-thread \
    --prefix=$BUILD_DIR
  emmake make install-lib-static -j${NPROC}
  cd $ROOT_DIR
}

build_x265() {
  cd third_party/x265/source
  rm -rf build
  mkdir build
  cd build
  emmake cmake .. \
    -G "Unix Makefiles" \
    -DENABLE_SHARED:bool=off \
    -DSTATIC_LINK_CRT:bool=on \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR
  emmake make install -j${NPROC}
  cd $ROOT_DIR
}

configure_ffmpeg() {
 PKG_CONFIG_PATH=/src/build/lib/pkgconfig emconfigure ./configure \
    --enable-gpl \
    --enable-libx264 \
    --enable-libx265 \
    --disable-pthreads \
    --disable-x86asm \
    --disable-inline-asm \
    --disable-doc \
    --disable-stripping \
    --disable-ffprobe \
    --disable-ffplay \
    --disable-ffmpeg \
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
  emmake make -j${NPROC}
}

build_ffmpegjs() {
  emcc \
    -I. -I./fftools -I$BUILD_DIR/include \
    -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -Llibpostproc -L${BUILD_DIR}/lib \
    -Qunused-arguments -Oz \
    -o dist/ffmpeg-core.js fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 -lx265 \
    --closure 1 \
    --pre-js javascript/prepend.js \
    -s USE_SDL=2 \
    -s MODULARIZE=1 \
    -s SINGLE_FILE=1 \
    -s EXPORTED_FUNCTIONS="[_ffmpeg]" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[cwrap, FS, getValue, setValue]" \
    -s TOTAL_MEMORY=33554432 \
    -s ASSERTIONS=1 \
    -s ALLOW_MEMORY_GROWTH=1
}

main() {
  #build_x264
  build_x265
  configure_ffmpeg
  make_ffmpeg
  build_ffmpegjs
}

main "$@"
