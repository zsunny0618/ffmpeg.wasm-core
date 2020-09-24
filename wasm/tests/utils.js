let Module = null;

exports.initModule = () => (
  new Promise((resolve) => {
    const _Module = require('../dist/ffmpeg-core.js');
    _Module.onRuntimeInitialized = () => {
      Module = _Module;
      resolve(Module);
    }
  })
);

exports.parseArgs = (args) => {
  const argsPtr = Module._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = Module._malloc(s.length + 1);
    Module.writeAsciiToMemory(s, buf);
    Module.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
  return [args.length, argsPtr];
};
