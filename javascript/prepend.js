var logger = function(){}

Module['setLogger'] = function(_logger) { logger = _logger; };
Module['print'] = function(message) { logger(message, 'stdout'); };
Module['printErr'] = function(message) { logger(message, 'stderr'); };
Module['preRun'] = [
  function() {
    FS.mkdir('/data');
    if (typeof process === 'object' && typeof require === 'function') {
      try {
        require('fs').mkdirSync('./data');
      } catch(e) {}
      FS.mount(NODEFS, { root: '.' }, '/data');
    } else if (typeof importScripts === 'function') {
      FS.mount(IDBFS, {}, '/data');
      FS.writeFile('/data/.DUMMY', new Uint8Array([]));
    }
  },
];