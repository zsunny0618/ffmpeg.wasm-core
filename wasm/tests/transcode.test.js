const fs = require('fs');
const path = require('path');
const { runFFmpeg } = require('./utils');
const aviFilePath = path.join(__dirname, 'data', 'video-3s.avi');
const TIMEOUT = 120000;
const MP4_SIZE = 98326;
const WEBM_SIZE = 114591;
let aviData = null;

beforeAll(async () => {
  aviData = Uint8Array.from(fs.readFileSync(aviFilePath));
});

test('transcode avi to x264 mp4', async () => {
  const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', 'video.mp4']);
  const fileSize = Core.FS.readFile('video.mp4').length;
  Core.FS.unlink('video.mp4');
  expect(fileSize).toBe(MP4_SIZE);
}, TIMEOUT);

test('transcode avi to x264 mp4 twice', async () => {
  for (let i = 0 ; i < 2; i++) {
    const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', 'video.mp4']);
    const fileSize = Core.FS.readFile('video.mp4').length;
    Core.FS.unlink('video.mp4');
    expect(fileSize).toBe(MP4_SIZE);
  }
}, TIMEOUT);

test('transcode avi to webm', async () => {
  const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', '-row-mt', '1', 'video.webm']);
  const fileSize = Core.FS.readFile('video.webm').length;
  Core.FS.unlink('video.webm');
  expect(fileSize).toBe(WEBM_SIZE);
}, TIMEOUT);

test('transcode avi to webm twice', async () => {
  for (let i = 0 ; i < 2; i++) {
  const Core = await runFFmpeg('video.avi', aviData, ['-i', 'video.avi', '-row-mt', '1', 'video.webm']);
    const fileSize = Core.FS.readFile('video.webm').length;
    Core.FS.unlink('video.webm');
    expect(fileSize).toBe(WEBM_SIZE);
  }
}, TIMEOUT);
