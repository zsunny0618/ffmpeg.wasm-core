const fs = require('fs');
const path = require('path');
const createFFmpegCore = require('../dist/ffmpeg-core');
const { parseArgs, ffmpeg } = require('./utils');
const filePath = path.join(__dirname, 'data', 'video-3s.avi');
let data = null;

beforeAll(async () => {
  data = Uint8Array.from(fs.readFileSync(filePath));
});

test('transcode avi to x264 mp4', async () => {
  let resolve = null;
  const Core = await createFFmpegCore({
    printErr: () => {},
    print: (m) => {
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    },
  });
  Core.FS.writeFile('video.avi', data);
  ffmpeg(Core, ['-i', 'video.avi', 'video.mp4']);
  await new Promise((_resolve) => { resolve = _resolve });
  const fileSize = Core.FS.readFile('video.mp4').length;
  Core.FS.unlink('video.mp4');
  expect(fileSize).toBe(98326);
}, 30000);

test('transcode avi to x264 mp4 twice', async () => {
  for (let i = 0 ; i < 2; i++) {
    let resolve = null;
    const Core = await createFFmpegCore({
      printErr: () => {},
      print: (m) => {
        if (m.startsWith('FFMPEG_END')) {
          resolve();
        }
      },
    });
    Core.FS.writeFile('video.avi', data);
    ffmpeg(Core, ['-i', 'video.avi', 'video.mp4']);
    await new Promise((_resolve) => { resolve = _resolve });
    const fileSize = Core.FS.readFile('video.mp4').length;
    Core.FS.unlink('video.mp4');
    expect(fileSize).toBe(98326);
  }
}, 30000);
