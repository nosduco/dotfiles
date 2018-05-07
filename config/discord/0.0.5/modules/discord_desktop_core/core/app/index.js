'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.startup = startup;
exports.handleSingleInstance = handleSingleInstance;
exports.setMainWindowVisible = setMainWindowVisible;

var _require = require('electron'),
    Menu = _require.Menu;

var mainScreen = void 0;
function startup(bootstrapModules) {
  // below modules are required and initted
  // in this order to prevent dependency conflicts
  // please don't tamper with the order unless you know what you're doing
  require('./bootstrapModules').init(bootstrapModules);

  require('./paths');
  require('./splashScreen');
  require('./moduleUpdater');
  require('./autoStart');
  var buildInfo = require('./buildInfo');
  var appSettings = require('./appSettings');

  var Constants = require('./Constants');
  Constants.init(bootstrapModules.Constants);

  var errorReporting = require('./errorReporting');
  errorReporting.init();

  var appFeatures = require('./appFeatures');
  appFeatures.init();

  var GPUSettings = require('./GPUSettings');
  bootstrapModules.GPUSettings.replace(GPUSettings);

  var rootCertificates = require('./rootCertificates');
  rootCertificates.init();

  // expose globals that will be imported by the webapp
  // global.releaseChannel is set in bootstrap
  global.crashReporterMetadata = errorReporting.metadata;
  global.mainAppDirname = Constants.MAIN_APP_DIRNAME;
  global.features = appFeatures.getFeatures();
  global.appSettings = appSettings.getSettings();
  // this gets updated when launching a new main app window
  global.mainWindowId = Constants.DEFAULT_MAIN_WINDOW_ID;

  var applicationMenu = require('./applicationMenu');
  Menu.setApplicationMenu(applicationMenu);

  mainScreen = require('./mainScreen');
  mainScreen.init();
}

function handleSingleInstance(args) {
  mainScreen.handleSingleInstance(args);
}

function setMainWindowVisible(visible) {
  mainScreen.setMainWindowVisible(visible);
}