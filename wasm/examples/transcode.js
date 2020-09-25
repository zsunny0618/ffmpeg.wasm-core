const path = require('path');
const fs = require('fs');
const createFFmpegCore = require('../dist/ffmpeg-core');

(async () => {
  let resolve = null;
  const Core = await createFFmpegCore({
    printErr: (m) => console.log(m),
    print: (m) => {
      console.log(m);
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    }
  });
  const filePath = path.join(__dirname, '..', 'tests', 'data', 'video-3s.avi');
  const data = Uint8Array.from(fs.readFileSync(filePath));
  Core.FS.writeFile('video.avi', data);

  const ffmpeg = Core.cwrap('proxy_main', 'number', ['number', 'number']);
  const args = ['ffmpeg', '-hide_banner', '-report', '-i', 'video.avi', 'video.mp4'];
  const argsPtr = Core._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = Core._malloc(s.length + 1);
    Core.writeAsciiToMemory(s, buf);
    Core.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
  console.time('execution time');
  ffmpeg(args.length, argsPtr);
  await new Promise((_resolve) => { resolve = _resolve });
  const output = Core.FS.readFile('video.mp4');
  fs.writeFileSync(path.join(__dirname, 'video.mp4'), output);
  console.timeEnd('execution time');
  process.exit(1);
})();
