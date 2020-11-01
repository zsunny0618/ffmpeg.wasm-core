const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'audio-1s.wav';
const OUT_FILE_NAME = 'audio.aac';
const FILE_SIZE = 4239;
let wavData = null;

beforeAll(() => {
  wavData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('convert wav to aac', async () => {
  const args = ['-i', IN_FILE_NAME, '-c:a', 'libfdk_aac', OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, wavData, args, OUT_FILE_NAME);
  expect(fileSize).toBe(FILE_SIZE);
}, TIMEOUT);
