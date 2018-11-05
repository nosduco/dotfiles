'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.metadata = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

exports.init = init;
exports.configureCrashReporter = configureCrashReporter;

var _electron = require('electron');

var _child_process = require('child_process');

var _child_process2 = _interopRequireDefault(_child_process);

var _buildInfo = require('./buildInfo');

var _buildInfo2 = _interopRequireDefault(_buildInfo);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var metadata = exports.metadata = {};

function init() {
  exports.metadata = metadata = {
    channel: _buildInfo2.default.releaseChannel
  };

  if (process.platform === 'linux') {
    var XDG_CURRENT_DESKTOP = process.env.XDG_CURRENT_DESKTOP || 'unknown';
    var GDMSESSION = process.env.GDMSESSION || 'unknown';
    metadata['wm'] = XDG_CURRENT_DESKTOP + ',' + GDMSESSION;
    try {
      metadata['distro'] = _child_process2.default.execFileSync('lsb_release', ['-ds'], { timeout: 100, maxBuffer: 512, encoding: 'utf-8' }).trim();
    } catch (e) {} // just in case lsb_release doesn't exist
  }

  configureCrashReporter();
  _electron.ipcMain.on('UPDATE_CRASH_REPORT', function (_event, extras) {
    configureCrashReporter(extras);
  });
}

// TODO: do we actually use this export now?
function configureCrashReporter(extras) {
  extras = extras || {};
  var extra = _extends({}, metadata, extras);
  _electron.crashReporter.start({
    productName: 'Discord',
    companyName: 'Discord Inc.',
    submitURL: 'http://crash.discordapp.com:1127/post',
    // [adill] remove autoSubmit once all channels are on 2.0.0+
    autoSubmit: true,
    uploadToServer: true,
    ignoreSystemCrashHandler: false,
    extra: extra
  });
}