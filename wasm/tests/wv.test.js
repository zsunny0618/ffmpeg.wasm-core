const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'audio-1s.wav';
const OUT_FILE_NAME = 'audio.wv';
const FILE_SIZE = 23502;
let wavData = null;

beforeAll(() => {
  wavData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('convert wav to wv', async () => {
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, wavData, args, OUT_FILE_NAME);
  expect(fileSize).toBe(FILE_SIZE);
}, TIMEOUT);
