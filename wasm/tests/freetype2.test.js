const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { runFFmpeg, b64ToUint8Array } = require('./utils');
const ARIAL_TTF = require('./data/arial.ttf.js');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mp4';
const FILE_SIZE = 37243;
let aviData = null;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

test('transcode avi to x264 mp4 with drawtext', async () => {
  const args = ['-i', IN_FILE_NAME, '-vf', 'drawtext=fontfile=/arial.ttf:text=\'Artist\':fontcolor=white:fontsize=24:x=(w-text_w)/2:y=(h-text_h)/2', OUT_FILE_NAME];
  const { fileSize } = await runFFmpeg(IN_FILE_NAME, aviData, args, OUT_FILE_NAME, [{ name: 'arial.ttf', data: b64ToUint8Array(ARIAL_TTF) }]);
  expect(fileSize).toBe(FILE_SIZE);
}, TIMEOUT);
