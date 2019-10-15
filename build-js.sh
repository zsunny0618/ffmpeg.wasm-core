#!/bin/bash -x

NPROC=$(grep -c ^processor /proc/cpuinfo)
FUNCTIONS=(
  _av_log_set_level
  _transcoding
)

EXPORTED_FUNCTIONS=${FUNCTIONS[0]}
unset FUNCTIONS[0]
for f in "${FUNCTIONS[@]}"; do
  EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS}, ${f}"
done

build_libmp3lame() {
  cd lame-3.100
  emconfigure ./configure --prefix=$PWD/../build
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
    --enable-libmp3lame \
    --prefix=$PWD/build \
    --extra-cflags=-I$PWD/build/include \
    --extra-ldflags=-L$PWD/build/lib \
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
    -I. -I$PWD/build/include \
    -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -L$PWD/build/lib \
    -Qunused-arguments \
    -o javascript/ffmpeg.js libffmpeg/transcoding.c \
    -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lmp3lame -lm \
    -s MODULARIZE=1 \
    -s EXPORTED_FUNCTIONS="[${EXPORTED_FUNCTIONS}]" \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[cwrap, FS, getValue, setValue]" \
    -s TOTAL_MEMORY=33554432 \
    -s ALLOW_MEMORY_GROWTH=1
}

main() {
  #build_libmp3lame
  #configure_ffmpeg
  #make_ffmpeg
  build_ffmpegjs
}

main "$@"
