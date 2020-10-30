const createFFmpegCore = require('../dist/ffmpeg-core');

const parseArgs = (Core, args) => {
  const argsPtr = Core._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = Core._malloc(s.length + 1);
    Core.writeAsciiToMemory(s, buf);
    Core.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
  return [args.length, argsPtr];
};

const ffmpeg = (Core, args) => {
  Core.ccall(
    'proxy_main',
    'number',
    ['number', 'number'],
    parseArgs(Core, ['ffmpeg', '-nostdin', ...args]),
  );
};

const runFFmpeg = async (ifilename, data, args, ofilename) => {
  let resolve = null;
  let file = null;
  let fileSize = -1;
  const Core = await createFFmpegCore({
    printErr: () => {},
    print: (m) => {
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    },
  });
  Core.FS.writeFile(ifilename, data);
  ffmpeg(Core, args);
  await new Promise((_resolve) => { resolve = _resolve });
  if (typeof ofilename !== 'undefined') {
    file = Core.FS.readFile(ofilename);
    fileSize = file.length;
    Core.FS.unlink(ofilename);
  }
  return { Core, file, fileSize };
};

module.exports = {
  runFFmpeg,
};
