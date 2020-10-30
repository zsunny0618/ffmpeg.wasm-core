const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mp4';
const MP4_10BIT_SIZE1 = 22507;
const MP4_10BIT_SIZE2 = 22520;
const MP4_12BIT_SIZE = 22718;
let aviData = null;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('transcode avi to x265 10bit mp4', async () => {
  const args = ['-i', IN_FILE_NAME, '-c:v', 'libx265', '-pix_fmt', 'yuv420p10le', OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
  expect(fileSize === MP4_10BIT_SIZE1 || fileSize === MP4_10BIT_SIZE2).toBe(true);
}, TIMEOUT);

test('transcode avi to x265 12bit mp4', async () => {
  const args = ['-i', IN_FILE_NAME, '-c:v', 'libx265', '-pix_fmt', 'yuv420p12le', OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
  expect(fileSize).toBe(MP4_12BIT_SIZE);
}, TIMEOUT);
