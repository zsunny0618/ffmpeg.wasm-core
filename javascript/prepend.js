var logger = function(){}

Module['setLogger'] = function(_logger) { logger = _logger; };
Module['print'] = function(message) { logger({ message, type: 'ffmpeg-stdout' }); };
Module['printErr'] = function(message) { logger({ message, type: 'ffmpeg-stderr' }); };
Module['locateFile'] = function(path, prefix) {
  if (typeof window !== 'undefined'
    && typeof window.FFMPEG_CORE_WORKER_SCRIPT !== 'undefined'
    && path.endsWith('ffmpeg-core.worker.js')) {
    return window.FFMPEG_CORE_WORKER_SCRIPT;
  }
  return prefix + path;
}
/*
Module['preRun'] = [
  function() {
    FS.mkdir('/data');
    if (typeof process === 'object' && typeof require === 'function') {
      try {
        require('fs').mkdirSync('./data');
      } catch(e) {}
      FS.mount(NODEFS, { root: './data' }, '/data');
    } else if (typeof importScripts === 'function') {
      FS.mount(IDBFS, {}, '/data');
      FS.writeFile('/data/.DUMMY', new Uint8Array([]));
    }
  },
];
*/
