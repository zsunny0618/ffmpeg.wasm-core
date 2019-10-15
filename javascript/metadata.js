const fs = require('fs');
const createFuncs = require('./createFuncs');

require('./ffmpeg.js')()
  .then((Module) => {
    Module.FS.writeFile('/tmp.wav', new Uint8Array(fs.readFileSync('./file_example_WAV_1MG.wav')));
    const {
      avformat_alloc_context,
      avformat_open_input,
      avformat_close_input,
      av_dict_get,
      av_fmt_ctx_get_metadata,
      av_dict_entry_get_key,
      av_dict_entry_get_value,
    } = createFuncs(Module);
    const fmt_ctx = avformat_alloc_context();
    let tag = 0;
    const fmt_ctx_ptr = Module._malloc(Uint32Array.BYTES_PER_ELEMENT);
    Module.setValue(fmt_ctx_ptr, fmt_ctx, 'i32');
    avformat_open_input(fmt_ctx_ptr, '/tmp.wav', 0, 0);
    while (true) {
      tag = av_dict_get(av_fmt_ctx_get_metadata(fmt_ctx), "", tag, 2);
      if (tag == 0) {
        break;
      }
      console.log(av_dict_entry_get_key(tag), '=', av_dict_entry_get_value(tag));
    }
    avformat_close_input(fmt_ctx_ptr);
  })
