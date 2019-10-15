const fs = require('fs');
const util = require('./util');

require('./ffmpeg')()
  .then((Module) => {
    Module.FS.writeFile('/tmp.wav', new Uint8Array(fs.readFileSync('./file_example_WAV_1MG.wav')));
    const transcoding = Module.cwrap('transcoding', 'number', ['number', 'number']);
    const av_log_set_level = Module.cwrap('av_log_set_level', 'number', ['number']);
    const { str2ptr } = util(Module);
    av_log_set_level(56); // -8 for quiet, 56 for trace
    transcoding(str2ptr('/tmp.wav'), str2ptr('test.mp3'));
  })
