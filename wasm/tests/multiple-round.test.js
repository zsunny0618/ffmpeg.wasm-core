const fs = require('fs');
const path = require('path');
const createFFmpegCore = require('../dist/ffmpeg-core');
const { TIMEOUT } = require('./config');
const { runFFmpeg, ffmpeg } = require('./utils');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mp4';
const MP4_SIZE = 38372;
let aviData = null;
let resolve = null;
let Core = null;

beforeAll(async () => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
  Core = await createFFmpegCore({
    printErr: (m) => {
    },
    print: (m) => {
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    }
  });
}, TIMEOUT);

test('should transcode to mp4 twice', async () => {
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  Core.FS.writeFile(IN_FILE_NAME, aviData);
  for (let i = 0; i < 2; i++) {
    ffmpeg(Core, args);
    await new Promise((_resolve) => { resolve = _resolve });
    expect(Core.FS.readFile(OUT_FILE_NAME).length).toBe(MP4_SIZE);
    Core.FS.unlink(OUT_FILE_NAME);
  }
}, TIMEOUT);
