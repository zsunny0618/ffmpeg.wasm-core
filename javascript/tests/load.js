const Core = require('../../dist/ffmpeg-core');

Core()
  .then((Module) => {
    console.log(JSON.stringify(Object.keys(Module)));
    process.exit(0);
  });
