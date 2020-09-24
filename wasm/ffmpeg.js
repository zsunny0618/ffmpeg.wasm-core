const path = require('path');
const fs = require('fs');
const Module = require('./dist/ffmpeg-core');

Module.onRuntimeInitialized = () => {
  const filePath = path.join(__dirname, 'tests', 'data', 'video-15s.avi');
  const data = Uint8Array.from(fs.readFileSync(filePath));
  Module.FS.writeFile('video.avi', data);

  const ffmpeg = Module.cwrap('proxy_main', 'number', ['number', 'number']);
  const args = ['ffmpeg', '-hide_banner', '-report', '-i', 'video.avi', 'video.mp4'];
  const argsPtr = Module._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = Module._malloc(s.length + 1);
    Module.writeAsciiToMemory(s, buf);
    Module.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
  console.time('execution time');
  ffmpeg(args.length, argsPtr);

  /*
   * The execution of ffmpeg is not synchronized,
   * so we need to parse the log file to check if completed.
   */
  const timer = setInterval(() => {
    const logFileName = Module.FS.readdir('.').find(name => name.endsWith('.log'));
    if (typeof logFileName !== 'undefined') {
      const log = String.fromCharCode.apply(null, Module.FS.readFile(logFileName));
      if (log.includes("frames successfully decoded")) {
        clearInterval(timer);
        const output = Module.FS.readFile('video.mp4');
        fs.writeFileSync('video.mp4', output);
        console.timeEnd('execution time');
        process.exit(1);
      }
    }
  }, 500);
};
