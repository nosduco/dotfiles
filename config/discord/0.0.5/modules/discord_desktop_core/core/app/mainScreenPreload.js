'use strict';

// App preload script, used to provide a replacement native API now that
// we turned off node integration.
var electron = require('electron');

var TRACK_ANALYTICS_EVENT = 'TRACK_ANALYTICS_EVENT';
var TRACK_ANALYTICS_EVENT_COMMIT = 'TRACK_ANALYTICS_EVENT_COMMIT';

// We don't care about logging these anymore.
// just commit so that they don't back up on disk.
electron.ipcRenderer.on(TRACK_ANALYTICS_EVENT, function (e) {
  e.sender.send(TRACK_ANALYTICS_EVENT_COMMIT);
});

var DiscordNative = {
  isRenderer: process.type === 'renderer',

  nativeModules: require('./discord_native/nativeModules'),
  globals: require('./discord_native/globals'),
  process: require('./discord_native/process'),
  os: require('./discord_native/os'),
  remoteApp: require('./discord_native/remoteApp'),
  clipboard: require('./discord_native/clipboard'),
  ipc: require('./discord_native/ipc'),
  gpuSettings: require('./discord_native/gpuSettings'),
  window: require('./discord_native/window'),
  remotePowerMonitor: require('./discord_native/remotePowerMonitor'),
  spellCheck: require('./discord_native/spellCheck'),
  crashReporter: require('./discord_native/crashReporter'),
  desktopCapture: require('./discord_native/desktopCapture'),
  fileManager: require('./discord_native/fileManager'),
  processUtils: require('./discord_native/processUtils')
};

var _setImmediate = setImmediate;
var _clearImmediate = clearImmediate;
process.once('loaded', function () {
  global.DiscordNative = DiscordNative;

  // We keep these two functions in global because electron doesn't put these
  // nodejs APIs in the module scope, and these two functions
  // aren't harmful at all.
  global.setImmediate = _setImmediate;
  global.clearImmediate = _clearImmediate;
});