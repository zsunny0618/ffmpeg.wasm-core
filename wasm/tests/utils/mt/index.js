const parseArgs = require('../parseArgs');
let resolve = null;

const ffmpeg = ({ core, args }) => {
  try {
    core.ccall(
      'proxy_main',  // use emscripten_proxy_main if emscripten upgraded
      'number',
      ['number', 'number'],
      parseArgs(core, ['ffmpeg', '-hide_banner', '-nostdin', ...args]),
    );
  } catch(e) {
    // TODO: only ignore certain exceptions
  }
  return new Promise((_resolve) => { resolve = _resolve; });
};

const getCore = () => (
  require('../../../packages/core/dist/ffmpeg-core')({
    printErr: () => {},
    print: (m) => {
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    },
  })
);

module.exports = {
  ffmpeg,
  getCore,
};
