const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const aviFilePath = path.join(__dirname, 'data', 'video-1s.avi');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.webm';
const WEBM_SIZE = 41904;
const WEBM_SIZE_MT = 41878;
let aviData = null;
let BASELINE_TIME = 0;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('transcode avi to vp9 webm', async () => {
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  const start = Date.now();
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
  BASELINE_TIME = Date.now() - start;
  expect(fileSize).toBe(WEBM_SIZE);
}, TIMEOUT);

test('transcode avi to vp9 webm with multithread', async () => {
  const args = ['-i', IN_FILE_NAME, '-row-mt', '1', OUT_FILE_NAME];
  const start = Date.now();
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
  const timediff = Date.now() - start;
  expect(fileSize).toBe(WEBM_SIZE_MT);
  expect(timediff < BASELINE_TIME).toBe(true);
}, TIMEOUT);
