const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const aviFilePath = path.join(__dirname, 'data', 'video-1s.avi');
const WEBM_SIZE = 41878;
let aviData = null;

beforeAll(async () => {
  aviData = Uint8Array.from(fs.readFileSync(aviFilePath));
});

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
