'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.hasInit = undefined;
exports.init = init;

var _electron = require('electron');

var _autoStart = require('./autoStart');

var autoStart = _interopRequireWildcard(_autoStart);

var _appSettings = require('./appSettings');

var _appFeatures = require('./appFeatures');

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

var settings = (0, _appSettings.getSettings)();
var features = (0, _appFeatures.getFeatures)();
var NOOP = function NOOP() {};

var hasInit = exports.hasInit = false;

function init() {
  if (hasInit) {
    console.warn('appConfig: Has already init! Cancelling init.');
    return;
  }
  exports.hasInit = hasInit = true;

  // TODO remove on or after March 2018
  features.declareSupported('app_configs');

  _electron.ipcMain.on('TOGGLE_MINIMIZE_TO_TRAY', function (_event, value) {
    return setMinimizeOnClose(value);
  });
  _electron.ipcMain.on('TOGGLE_OPEN_ON_STARTUP', function (_event, value) {
    return toggleRunOnStartup(value);
  });
  _electron.ipcMain.on('TOGGLE_START_MINIMIZED', function (_event, value) {
    return toggleStartMinimized(value);
  });
}

function setMinimizeOnClose(minimizeToTray) {
  settings.set('MINIMIZE_TO_TRAY', minimizeToTray);
}

function toggleRunOnStartup(openOnStartup) {
  settings.set('OPEN_ON_STARTUP', openOnStartup);

  if (openOnStartup) {
    autoStart.install(NOOP);
  } else {
    autoStart.uninstall(NOOP);
  }
}

function toggleStartMinimized(startMinimized) {
  settings.set('START_MINIMIZED', startMinimized);
  autoStart.isInstalled(function (installed) {
    // Only update the registry for this toggle if the app was already set to autorun
    if (installed) {
      autoStart.install(NOOP);
    }
  });
}