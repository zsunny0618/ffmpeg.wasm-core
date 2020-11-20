const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'image.png';
const OUT_FILE_NAME = 'image.webp';
const FILE_SIZE = 6376;
let pngData = null;

beforeAll(() => {
  pngData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('transcode png to webp', async () => {
  const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, pngData, args, OUT_FILE_NAME);
  expect(fileSize).toBe(FILE_SIZE);
}, TIMEOUT);
