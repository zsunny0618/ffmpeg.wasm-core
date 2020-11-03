Module['locateFile'] = function(path, prefix) {
  if (typeof window !== 'undefined'
    && typeof window.FFMPEG_CORE_WORKER_SCRIPT !== 'undefined'
    && path.endsWith('ffmpeg-core.worker.js')) {
    return window.FFMPEG_CORE_WORKER_SCRIPT;
  }
  return prefix + path;
}
