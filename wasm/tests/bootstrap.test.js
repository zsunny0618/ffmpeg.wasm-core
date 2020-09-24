const {
  initModule,
  parseArgs,
} = require('./utils');
let Module = null;
let ffmpeg = null;

beforeAll(async () => {
  Module = await initModule();
  ffmpeg = Module.cwrap('proxy_main', 'number', ['number', 'number']);
});

test('test', () => {
  const ret = ffmpeg(...parseArgs(['ffmpeg', '-v']));
  expect(ret).toBe(0);
});
