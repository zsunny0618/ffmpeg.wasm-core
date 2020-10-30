FFmpeg.wasm Core
================
![FFmpeg.wasm Core](https://github.com/ffmpegwasm/ffmpeg.wasm-core/workflows/FFmpeg.wasm/badge.svg?branch=n4.3.1-wasm)

This is the core part of FFmpeg.wasm where we transpile C/C++ code of FFmpeg to JavaScript/WebAssembly code. It is still very experimental (and slow), but shows the possibilities of using FFmpeg purely in the browser.

If you have any issues for this repository, please put it here: https://github.com/ffmpegwasm/ffmpeg.wasm/issues

## Setup

```
$ git clone https://github.com/ffmpegwasm/ffmpeg.wasm-core
$ git submodule update --init --recursive
```

## Build

1. Use docker (easy way)

Install latest docker and run `build-with-docker.sh`.

```
$ bash build-with-docker.sh
```

2. Install emsdk (unstable way)

Setup the emsdk from [HERE](https://emscripten.org/docs/getting_started/downloads.html) and run `build.sh`.

```
$ bash build.sh
```

If nothing goes wrong, you can find JavaScript files in `wasm/dist`.

## Test

Once the build completes, you can test with following scripts:

```
$ cd wasm
$ npm install
$ npm test
```

## Configuration

#### Base

- Emscripten: 2.0.8
- FFmpeg: 4.3.1

#### Video

- x264 (mp4): 0.160.x
- x265 (mp4): 3.4 (only works with `-pix_fmt yuv420p10le` and `-pix_fmt yuv420p12le`)
- libvpx (webm): 1.9.0
- theora (ogv): 1.1.1

#### Audio

- wavpack (wav): 5.3.0
- lame (mp3): 3.100
- fdk-aac (aac); 2.0.1
- ogg: 1.3.4
- vorbis (ogg): 1.3.6
