const fs = require('fs');
const Module = require('./dist/ffmpeg-core');

Module.onRuntimeInitialized = () => {
  const data = Uint8Array.from(fs.readFileSync('../testdata/flame.avi'));
  Module.FS.writeFile('flame.avi', data);

  const ffmpeg = Module.cwrap('proxy_main', 'number', ['number', 'number']);
  const args = ['ffmpeg', '-hide_banner', '-report', '-i', 'flame.avi', 'flame.mp4'];
  const argsPtr = Module._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = Module._malloc(s.length + 1);
    Module.writeAsciiToMemory(s, buf);
    Module.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
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
        const output = Module.FS.readFile('flame.mp4');
        fs.writeFileSync('flame.mp4', output);
      }
    }
  }, 500);
};
