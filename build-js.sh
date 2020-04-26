#!/bin/bash -x

set -e -o pipefail

NPROC=$(grep -c ^processor /proc/cpuinfo)
ROOT_DIR=$PWD
BUILD_DIR=$ROOT_DIR/build
EM_TOOLCHAIN_FILE=/emsdk_portable/emscripten/tag-1.39.0/cmake/Modules/Platform/Emscripten.cmake

build_zlib() {
  cd third_party/zlib
  rm -rf build zconf.h
  mkdir build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${BUILD_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF
  emmake make install -j${NPROC}
  cd ${ROOT_DIR}
}

build_x264() {
  cd third_party/x264
  emconfigure ./configure \
    --enable-static \
    --disable-cli \
    --disable-asm \
    --disable-thread \
    --host=i686-linux \
    --prefix=$BUILD_DIR
  emmake make install-lib-static -j${NPROC}
  cd ${ROOT_DIR}
}

build_libwebp() {
  cd third_party/libwebp
  rm -rf build
  mkdir build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${BUILD_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -DBUILD_SHARED_LIBS=OFF \
    -DWEBP_BUILD_WEBP_JS=ON
  emmake make install -j${NPROC}
  cd ${ROOT_DIR}
}

build_libvpx() {
  cd third_party/libvpx
  export AS=llvm-as
  export STRIP=llvm-strip
  emconfigure ./configure \
    --disable-examples \
    --disable-tools \
    --disable-docs \
    --disable-unit-tests \
    --target=generic-gnu \
    --prefix=$BUILD_DIR
  emmake make install -j${NPROC}
  cd ${ROOT_DIR}
}

configure_ffmpeg() {
  emconfigure ./configure \
    --enable-gpl \
    --enable-libx264 \
    --enable-libvpx \
    --disable-pthreads \
    --disable-x86asm \
    --disable-inline-asm \
    --disable-doc \
    --disable-stripping \
    --disable-ffprobe \
    --disable-ffplay \
    --disable-ffmpeg \
    --ignore-tests=$(cat all-tests) \
    --prefix=$BUILD_DIR \
    --extra-cflags="-I$BUILD_DIR/include" \
    --extra-cxxflags="-I$BUILD_DIR/include" \
    --extra-ldflags="-L$BUILD_DIR/lib" \
    --nm="llvm-nm -g" \
    --ar=emar \
    --as=llvm-as \
    --ranlib=llvm-ranlib \
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
    -o $2 fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 -lz -lvpx \
    --closure 1 \
    --pre-js javascript/prepend.js \
    --post-js javascript/post.js \
    -s USE_SDL=2 \
    -s MODULARIZE=1 \
    -s SINGLE_FILE=$1 \
    -s EXPORTED_FUNCTIONS="[_ffmpeg]" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[cwrap, FS, getValue, setValue]" \
    -s TOTAL_MEMORY=33554432 \
    -s ALLOW_MEMORY_GROWTH=1
}

main() {
  build_zlib
  build_x264
  build_libvpx
  configure_ffmpeg
  make_ffmpeg
  build_ffmpegjs 1 dist/ffmpeg-core.js
  build_ffmpegjs 0 dist-wasm/ffmpeg-core.js
}

main "$@"
