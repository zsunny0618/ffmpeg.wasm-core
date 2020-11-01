const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mp4';
const FILE_SIZE = 38372;
let aviData = null;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('transcode avi to x264 mp4', async () => {
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
  expect(fileSize).toBe(FILE_SIZE);
}, TIMEOUT);
