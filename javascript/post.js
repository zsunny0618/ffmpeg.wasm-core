Module['syncfs'] = function(populate) {
  return new Promise(function(resolve, reject) {
    Module.FS.syncfs(populate, function(err) {
      if (err) {
        reject(err);
      } else {
        resolve();
      }
    });
  });
}
