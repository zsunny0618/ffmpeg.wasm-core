#!/bin/bash -x

set -eo pipefail

BUILD_DIR=$1

mkdir -p wasm/dist
ARGS=(
  -I. -I./fftools -I$BUILD_DIR/include
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample -L$BUILD_DIR/lib
  -Qunused-arguments
  -o wasm/dist/ffmpeg-core.js fftools/ffmpeg_opt.c fftools/ffmpeg_filter.c fftools/ffmpeg_hw.c fftools/cmdutils.c fftools/ffmpeg.c
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil -lpostproc -lm -lx264 -pthread
  -O3                                           # Optimize code with performance first
  -s USE_SDL=2                                  # use SDL2
  -s USE_PTHREADS=1                             # enable pthreads support
  -s PROXY_TO_PTHREAD=1                         # detach main() from browser/UI main thread
  -s INVOKE_RUN=0                               # not to run the main() in the beginning
  -s EXPORTED_FUNCTIONS="[_main, _proxy_main]"  # export main and proxy_main funcs
  -s EXTRA_EXPORTED_RUNTIME_METHODS="[FS, cwrap, setValue, writeAsciiToMemory]"   # export preamble funcs
  -s INITIAL_MEMORY=268435456                   # 268435456 bytes = 256 MB
)
emcc "${ARGS[@]}"
