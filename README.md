FFmpeg.wasm Core
================
![FFmpeg.wasm Core](https://github.com/ffmpegwasm/ffmpeg.wasm-core/workflows/FFmpeg.wasm/badge.svg?branch=n4.3.1-wasm)

This is the core part of FFmpeg.wasm where we transpile C/C++ code of FFmpeg to JavaScript/WebAssembly code. It is still very experimental (and slow), but shows the possibilities of using FFmpeg right purely in your browser.

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

## Configuration

#### Base

- Emscripten: 2.0.8
- FFmpeg: 4.3.1

#### Video

- x264 (mp4): 0.160.x
- libvpx (webm): 1.9.0

#### Audio

- wavpack (wav): 5.3.0
