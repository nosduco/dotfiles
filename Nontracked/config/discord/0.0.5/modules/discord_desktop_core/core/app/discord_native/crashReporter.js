'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var electron = require('electron');
var globals = require('./globals');
var ipcRenderer = electron.ipcRenderer;
var crashReporter = electron.crashReporter;

var UPDATE_CRASH_REPORT = 'UPDATE_CRASH_REPORT';

function updateCrashReporter(metadata) {
  var extra = _extends({}, globals.crashReporterMetadata, metadata);
  ipcRenderer.send(UPDATE_CRASH_REPORT, metadata);
  crashReporter.start({
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

module.exports = {
  updateCrashReporter: updateCrashReporter
};