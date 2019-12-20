FFmpeg.js Core
=============

FFmpeg is a collection of libraries and tools to process multimedia content
such as audio, video, subtitles and related metadata.

This repository is a fork of FFmpeg to build ffmpeg-core.js, you can find build scripts
in **build-with-docker.sh** and **build-js.sh**

To build ffmpeg-core.js, install Docker and execute:

```bash
$ git submodule init
$ git submodule update --recursive
$ bash build-with-docker.sh
```

It outputs ffmpeg-core.js in **dist/** directory.

More details about FFmpeg: https://github.com/FFmpeg/FFmpeg
