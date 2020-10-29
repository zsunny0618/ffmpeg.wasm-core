const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg } = require('./utils');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mp4';
const MP4_SIZE = 38372;
let aviData = null;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('should transcode to mp4 twice', async () => {
  for (let i = 0 ; i < 2; i++) {
    const args = ['-i', IN_FILE_NAME, OUT_FILE_NAME];
    const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME);
    expect(fileSize).toBe(MP4_SIZE);
  }
}, TIMEOUT);
