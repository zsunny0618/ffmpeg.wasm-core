const fs = require('fs');
const util = require('./util');

require('./ffmpeg-core')()
  .then((Module) => {
    Module.FS.writeFile('/testcase.mp3', new Uint8Array(fs.readFileSync('../third_party/lame/testcase.mp3')));
    const transcoding = Module.cwrap('transcoding', 'number', ['number', 'number']);
    const av_log_set_level = Module.cwrap('av_log_set_level', 'number', ['number']);
    const { str2ptr } = util(Module);
    av_log_set_level(56); // -8 for quiet, 56 for trace
    transcoding(str2ptr('/testcase.mp3'), str2ptr('testcase.aac'));
    fs.writeFileSync('testcase.aac', Buffer.from(Module.FS.readFile('testcase.aac')));
  })
