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
    parseArgs(Core, ['ffmpeg', '-hide_banner', '-nostdin', ...args]),
  );
};

const runFFmpeg = async (ifilename, data, args, ofilename, extraFiles = [], extraFolders = [], msBeforeExit = -1) => {
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
  extraFolders.forEach((f) => {
    Core.FS.mkdir(f);
  });
  extraFiles.forEach(({ name, data: d }) => {
    Core.FS.writeFile(name, d);
  });
  Core.FS.writeFile(ifilename, data);
  ffmpeg(Core, args);
  if (msBeforeExit !== -1) {
    setTimeout(() => {
      Core.exit();
      resolve();
    }, msBeforeExit);
  }
  await new Promise((_resolve) => { resolve = _resolve });
  if (typeof ofilename !== 'undefined') {
    file = Core.FS.readFile(ofilename);
    fileSize = file.length;
    Core.FS.unlink(ofilename);
  }
  return { Core, file, fileSize };
};

const b64ToUint8Array = (str) => (Buffer.from(str, 'base64'));

module.exports = {
  runFFmpeg,
  b64ToUint8Array,
  ffmpeg,
};
