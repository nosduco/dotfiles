'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.cleanOldVersions = cleanOldVersions;
exports.init = init;
exports.getUserData = getUserData;
exports.getUserDataVersioned = getUserDataVersioned;
exports.getResources = getResources;
exports.getModulePath = getModulePath;

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _mkdirp = require('mkdirp');

var _mkdirp2 = _interopRequireDefault(_mkdirp);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _rimraf = require('rimraf');

var _rimraf2 = _interopRequireDefault(_rimraf);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// Determines environment-specific paths based on info provided
var originalFs = void 0;
if (__SDK__) {
  originalFs = require('fs');
} else {
  originalFs = require('original-fs');
}

var userDataPath = null;
var userDataVersionedPath = null;
var resourcesPath = null;
var modulePath = null;

function determineSDKUserDataRoot() {
  switch (process.platform) {
    case 'darwin':
      return _path2.default.join(process.env.HOME, 'Library', 'Application Support');
    case 'win32':
      return process.env.APPDATA;
    case 'linux':
      return process.env.XDG_CONFIG_HOME || _path2.default.join(process.env.HOME, '.config');
  }
}

function determineAppUserDataRoot() {
  var _require = require('electron'),
      app = _require.app;

  return app.getPath('appData');
}

function determineUserData(userDataRoot, buildInfo) {
  var userDataPath = _path2.default.join(userDataRoot, 'discord' + (buildInfo.releaseChannel == 'stable' ? '' : buildInfo.releaseChannel));

  if (buildInfo.userDataSuffix) {
    userDataPath = _path2.default.join(userDataPath, buildInfo.userDataSuffix);
  }

  return userDataPath;
}

// cleans old version data in the background
function cleanOldVersions(buildInfo) {
  var entries = _fs2.default.readdirSync(userDataPath) || [];
  entries.forEach(function (entry) {
    var fullPath = _path2.default.join(userDataPath, entry);
    if (_fs2.default.statSync(fullPath).isDirectory() && entry.indexOf(buildInfo.version) === -1) {
      if (entry.match('^[0-9]+.[0-9]+.[0-9]+') != null) {
        console.log('Removing old directory ', entry);
        (0, _rimraf2.default)(fullPath, originalFs, function (error) {
          if (error) {
            console.warn('...failed with error: ', error);
          }
        });
      }
    }
  });
}

function init(buildInfo) {
  resourcesPath = __SDK__ ? __dirname : _path2.default.join(require.main.filename, '..', '..', '..');

  var userDataRoot = __SDK__ ? determineSDKUserDataRoot() : determineAppUserDataRoot();

  userDataPath = determineUserData(userDataRoot, buildInfo);

  if (!__SDK__) {
    var _require2 = require('electron'),
        app = _require2.app;

    app.setPath('userData', userDataPath);
  }

  userDataVersionedPath = _path2.default.join(userDataPath, buildInfo.version);
  _mkdirp2.default.sync(userDataVersionedPath);

  modulePath = buildInfo.localModulesRoot ? buildInfo.localModulesRoot : _path2.default.join(userDataVersionedPath, 'modules');
}

function getUserData() {
  return userDataPath;
}

function getUserDataVersioned() {
  return userDataVersionedPath;
}

function getResources() {
  return resourcesPath;
}

function getModulePath() {
  return modulePath;
}