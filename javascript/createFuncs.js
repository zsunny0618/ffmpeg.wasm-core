module.exports = (Module) => ({
  avformat_alloc_context: Module.cwrap('avformat_alloc_context', 'number', []),
  avformat_open_input: Module.cwrap('avformat_open_input', 'number', ['number', 'string', 'number', 'number']),
  avformat_close_input: Module.cwrap('avformat_close_input', null, ['number']),
  av_fmt_ctx_get_metadata: Module.cwrap('av_fmt_ctx_get_metadata', 'number', ['number']),
  create_av_dict_entry: Module.cwrap('create_av_dict_entry', 'number', []),
  av_dict_get: Module.cwrap('av_dict_get', 'number', ['number', 'string', 'number', 'number']),
  av_dict_entry_get_key: Module.cwrap('av_dict_entry_get_key', 'string', ['number']),
  av_dict_entry_get_value: Module.cwrap('av_dict_entry_get_value', 'string', ['number']),
  av_log_set_level: Module.cwrap('av_log_set_level', 'number', ['number']),
  ffmpeg_parse_options: Module.cwrap('ffmpeg_parse_options', 'number', ['number', 'number']),
  transcode: Module.cwrap('transcode', 'number', []),
});
