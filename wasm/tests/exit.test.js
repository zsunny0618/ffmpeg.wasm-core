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

test('transcode avi to x264 mp4 with exit', async () => {
  const processExit = process.exit;
  global.process.exit = jest.fn();
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME, [], [], 1000);
  expect(fileSize).not.toBe(FILE_SIZE);
  global.process.exit = processExit;
}, TIMEOUT);
