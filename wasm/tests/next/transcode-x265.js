const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const aviFilePath = path.join(__dirname, 'data', 'video-1s.avi');
const MP4_SIZE = 38372;
let aviData = null;

beforeAll(async () => {
  aviData = Uint8Array.from(fs.readFileSync(aviFilePath));
});

test('transcode avi to x265 mp4', async () => {
  const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', '-c:v', 'libx265', 'video.mp4']);
  const fileSize = Core.FS.readFile('video.mp4').length;
  Core.FS.unlink('video.mp4');
  expect(fileSize).toBe(MP4_SIZE);
}, TIMEOUT);

test('transcode avi to x265 mp4 twice', async () => {
  for (let i = 0 ; i < 2; i++) {
    const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', '-c:v', 'libx265', 'video.mp4']);
    const fileSize = Core.FS.readFile('video.mp4').length;
    Core.FS.unlink('video.mp4');
    expect(fileSize).toBe(MP4_SIZE);
  }
}, TIMEOUT);
