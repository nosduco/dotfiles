'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.events = exports.NO_PENDING_UPDATES = exports.INSTALLING_MODULE_PROGRESS = exports.INSTALLING_MODULE = exports.INSTALLING_MODULES_FINISHED = exports.DOWNLOADED_MODULE = exports.UPDATE_MANUALLY = exports.DOWNLOADING_MODULES_FINISHED = exports.DOWNLOADING_MODULE_PROGRESS = exports.DOWNLOADING_MODULE = exports.UPDATE_CHECK_FINISHED = exports.INSTALLED_MODULE = exports.CHECKING_FOR_UPDATES = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _get = function get(object, property, receiver) { if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { return get(parent, property, receiver); } } else if ("value" in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } };

exports.initPathsOnly = initPathsOnly;
exports.init = init;
exports.checkForUpdates = checkForUpdates;
exports.quitAndInstallUpdates = quitAndInstallUpdates;
exports.isInstalled = isInstalled;
exports.getInstalled = getInstalled;
exports.install = install;
exports.installPendingUpdates = installPendingUpdates;

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _module = require('module');

var _module2 = _interopRequireDefault(_module);

var _events = require('events');

var _mkdirp = require('mkdirp');

var _mkdirp2 = _interopRequireDefault(_mkdirp);

var _yauzl = require('yauzl');

var _yauzl2 = _interopRequireDefault(_yauzl);

var _paths = require('./paths');

var paths = _interopRequireWildcard(_paths);

var _Backoff = require('./Backoff');

var _Backoff2 = _interopRequireDefault(_Backoff);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; } // Manages additional module installation and management.
// We add the module folder path to require() lookup paths here.

// undocumented node API


var originalFs = void 0;
if (__SDK__) {
  originalFs = require('fs');
} else {
  originalFs = require('original-fs');
}

var Events = function (_EventEmitter) {
  _inherits(Events, _EventEmitter);

  function Events() {
    _classCallCheck(this, Events);

    return _possibleConstructorReturn(this, (Events.__proto__ || Object.getPrototypeOf(Events)).apply(this, arguments));
  }

  _createClass(Events, [{
    key: 'emit',
    value: function emit() {
      var _this2 = this;

      for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      process.nextTick(function () {
        return _get(Events.prototype.__proto__ || Object.getPrototypeOf(Events.prototype), 'emit', _this2).apply(_this2, args);
      });
    }
  }]);

  return Events;
}(_events.EventEmitter);

var LogStream = function () {
  function LogStream(logPath) {
    _classCallCheck(this, LogStream);

    try {
      this.logStream = _fs2.default.createWriteStream(logPath, { flags: 'a' });
    } catch (e) {
      console.error('Failed to create ' + logPath + ': ' + String(e));
    }
  }

  _createClass(LogStream, [{
    key: 'log',
    value: function log(message) {
      message = '[Modules] ' + message;
      console.log(message);
      if (this.logStream) {
        this.logStream.write(message);
        this.logStream.write('\r\n');
      }
    }
  }, {
    key: 'end',
    value: function end() {
      if (this.logStream) {
        this.logStream.end();
        this.logStream = null;
      }
    }
  }]);

  return LogStream;
}();

// events


var CHECKING_FOR_UPDATES = exports.CHECKING_FOR_UPDATES = 'checking-for-updates';
var INSTALLED_MODULE = exports.INSTALLED_MODULE = 'installed-module';
var UPDATE_CHECK_FINISHED = exports.UPDATE_CHECK_FINISHED = 'update-check-finished';
var DOWNLOADING_MODULE = exports.DOWNLOADING_MODULE = 'downloading-module';
var DOWNLOADING_MODULE_PROGRESS = exports.DOWNLOADING_MODULE_PROGRESS = 'downloading-module-progress';
var DOWNLOADING_MODULES_FINISHED = exports.DOWNLOADING_MODULES_FINISHED = 'downloading-modules-finished';
var UPDATE_MANUALLY = exports.UPDATE_MANUALLY = 'update-manually';
var DOWNLOADED_MODULE = exports.DOWNLOADED_MODULE = 'downloaded-module';
var INSTALLING_MODULES_FINISHED = exports.INSTALLING_MODULES_FINISHED = 'installing-modules-finished';
var INSTALLING_MODULE = exports.INSTALLING_MODULE = 'installing-module';
var INSTALLING_MODULE_PROGRESS = exports.INSTALLING_MODULE_PROGRESS = 'installing-module-progress';
var NO_PENDING_UPDATES = exports.NO_PENDING_UPDATES = 'no-pending-updates';

// settings
var ALWAYS_ALLOW_UPDATES = 'ALWAYS_ALLOW_UPDATES';
var SKIP_HOST_UPDATE = 'SKIP_HOST_UPDATE';
var SKIP_MODULE_UPDATE = 'SKIP_MODULE_UPDATE';
var ALWAYS_BOOTSTRAP_MODULES = 'ALWAYS_BOOTSTRAP_MODULES';
var USE_LOCAL_MODULE_VERSIONS = 'USE_LOCAL_MODULE_VERSIONS';

var request = __SDK__ ? require('request') : require('../app_bootstrap/request');
var REQUEST_TIMEOUT = 15000;
var backoff = new _Backoff2.default(1000, 20000);
var events = exports.events = new Events();

var logger = void 0;
var locallyInstalledModules = void 0;
var moduleInstallPath = void 0;
var installedModulesFilePath = void 0;
var moduleDownloadPath = void 0;
var bootstrapping = void 0;
var hostUpdater = void 0;
var hostUpdateAvailable = void 0;
var skipHostUpdate = void 0;
var skipModuleUpdate = void 0;
var checkingForUpdates = void 0;
var remoteBaseURL = void 0;
var remoteQuery = void 0;
var settings = void 0;
var remoteModuleVersions = void 0;
var installedModules = void 0;
var download = void 0;
var unzip = void 0;
var newInstallInProgress = void 0;
var localModuleVersionsFilePath = void 0;
var updatable = void 0;
var bootstrapManifestFilePath = void 0;

function initPathsOnly(_buildInfo) {
  if (locallyInstalledModules || moduleInstallPath) {
    return;
  }

  // If we have `localModulesRoot` in our buildInfo file, we do not fetch modules
  // from remote, and rely on our locally bundled ones.
  // Typically used for development mode, or private builds.
  locallyInstalledModules = _buildInfo.localModulesRoot != null;

  if (locallyInstalledModules) {
    if (_module2.default.globalPaths.indexOf(_buildInfo.localModulesRoot) === -1) {
      _module2.default.globalPaths.push(_buildInfo.localModulesRoot);
    }
  } else {
    moduleInstallPath = _path2.default.join(paths.getUserDataVersioned(), 'modules');
    if (_module2.default.globalPaths.indexOf(moduleInstallPath) === -1) {
      _module2.default.globalPaths.push(moduleInstallPath);
    }
  }
}

function init(_endpoint, _settings, _buildInfo) {
  var endpoint = _endpoint;
  settings = _settings;
  var buildInfo = _buildInfo;
  updatable = buildInfo.version != '0.0.0' && !buildInfo.debug || settings.get(ALWAYS_ALLOW_UPDATES);

  initPathsOnly(buildInfo);

  logger = new LogStream(_path2.default.join(paths.getUserData(), 'modules.log'));
  bootstrapping = false;
  hostUpdateAvailable = false;
  checkingForUpdates = false;
  skipHostUpdate = settings.get(SKIP_HOST_UPDATE) || __SDK__ || !updatable;
  skipModuleUpdate = settings.get(SKIP_MODULE_UPDATE) || locallyInstalledModules || !updatable;
  localModuleVersionsFilePath = _path2.default.join(paths.getUserData(), 'local_module_versions.json');
  bootstrapManifestFilePath = _path2.default.join(paths.getResources(), 'bootstrap', 'manifest.json');
  installedModules = {};
  remoteModuleVersions = {};
  newInstallInProgress = {};

  download = {
    // currently downloading
    active: false,
    // {name, version}
    queue: [],
    // current queue index being downloaded
    next: 0,
    // download failure count
    failures: 0
  };

  unzip = {
    // currently unzipping
    active: false,
    // {name, version, zipfile}
    queue: [],
    // current queue index being unzipped
    next: 0,
    // unzip failure count
    failures: 0
  };

  logger.log('Modules initializing');
  logger.log('Distribution: ' + (locallyInstalledModules ? 'local' : 'remote'));
  logger.log('Host updates: ' + (skipHostUpdate ? 'disabled' : 'enabled'));
  logger.log('Module updates: ' + (skipModuleUpdate ? 'disabled' : 'enabled'));

  if (!locallyInstalledModules) {
    installedModulesFilePath = _path2.default.join(moduleInstallPath, 'installed.json');
    moduleDownloadPath = _path2.default.join(moduleInstallPath, 'pending');
    _mkdirp2.default.sync(moduleDownloadPath);

    logger.log('Module install path: ' + moduleInstallPath);
    logger.log('Module installed file path: ' + installedModulesFilePath);
    logger.log('Module download path: ' + moduleDownloadPath);

    var failedLoadingInstalledModules = false;
    try {
      installedModules = JSON.parse(_fs2.default.readFileSync(installedModulesFilePath));
    } catch (err) {
      failedLoadingInstalledModules = true;
    }

    cleanDownloadedModules(installedModules);

    bootstrapping = failedLoadingInstalledModules || settings.get(ALWAYS_BOOTSTRAP_MODULES);
  }

  var setFeedURL = function setFeedURL(_) {};
  if (!__SDK__) {
    hostUpdater = require('../app_bootstrap/hostUpdater');
    // TODO: hostUpdater constants
    hostUpdater.on('checking-for-update', function () {
      return events.emit(CHECKING_FOR_UPDATES);
    });
    hostUpdater.on('update-available', function () {
      return hostOnUpdateAvailable();
    });
    hostUpdater.on('update-progress', function (progress) {
      return hostOnUpdateProgress(progress);
    });
    hostUpdater.on('update-not-available', function () {
      return hostOnUpdateNotAvailable();
    });
    hostUpdater.on('update-manually', function (newVersion) {
      return hostOnUpdateManually(newVersion);
    });
    hostUpdater.on('update-downloaded', function () {
      return hostOnUpdateDownloaded();
    });
    hostUpdater.on('error', function (err) {
      return hostOnError(err);
    });
    setFeedURL = hostUpdater.setFeedURL.bind(hostUpdater);
  }

  remoteBaseURL = endpoint + '/modules/' + buildInfo.releaseChannel;
  // eslint-disable-next-line camelcase
  remoteQuery = { host_version: buildInfo.version };

  switch (process.platform) {
    case 'darwin':
      setFeedURL(endpoint + '/updates/' + buildInfo.releaseChannel + '?platform=osx&version=' + buildInfo.version);
      remoteQuery.platform = 'osx';
      break;
    case 'win32':
      // Squirrel for Windows can't handle query params
      // https://github.com/Squirrel/Squirrel.Windows/issues/132
      setFeedURL(endpoint + '/updates/' + buildInfo.releaseChannel);
      remoteQuery.platform = 'win';
      break;
    case 'linux':
      setFeedURL(endpoint + '/updates/' + buildInfo.releaseChannel + '?platform=linux&version=' + buildInfo.version);
      remoteQuery.platform = 'linux';
      break;
  }
}

function cleanDownloadedModules(installedModules) {
  try {
    var entries = _fs2.default.readdirSync(moduleDownloadPath) || [];
    entries.forEach(function (entry) {
      var entryPath = _path2.default.join(moduleDownloadPath, entry);
      var isStale = true;
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = Object.keys(installedModules)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var moduleName = _step.value;

          if (entryPath === installedModules[moduleName].updateZipfile) {
            isStale = false;
            break;
          }
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }

      if (isStale) {
        _fs2.default.unlinkSync(_path2.default.join(moduleDownloadPath, entry));
      }
    });
  } catch (err) {
    logger.log('Could not clean downloaded modules');
    logger.log(err.stack);
  }
}

function hostOnUpdateAvailable() {
  logger.log('Host update is available.');
  hostUpdateAvailable = true;
  events.emit(UPDATE_CHECK_FINISHED, true, 1, false);
  events.emit(DOWNLOADING_MODULE, 'host', 1, 1);
}

function hostOnUpdateProgress(progress) {
  logger.log('Host update progress: ' + progress + '%');
  events.emit(DOWNLOADING_MODULE_PROGRESS, 'host', progress);
}

function hostOnUpdateNotAvailable() {
  logger.log('Host is up to date.');
  if (!skipModuleUpdate) {
    checkForModuleUpdates();
  } else {
    events.emit(UPDATE_CHECK_FINISHED, true, 0, false);
  }
}

function hostOnUpdateManually(newVersion) {
  logger.log('Host update is available. Manual update required!');
  hostUpdateAvailable = true;
  checkingForUpdates = false;
  events.emit(UPDATE_MANUALLY, newVersion);
  events.emit(UPDATE_CHECK_FINISHED, true, 1, true);
}

function hostOnUpdateDownloaded() {
  logger.log('Host update downloaded.');
  checkingForUpdates = false;
  events.emit(DOWNLOADED_MODULE, 'host', 1, 1, true);
  events.emit(DOWNLOADING_MODULES_FINISHED, 1, 0);
}

function hostOnError(err) {
  logger.log('Host update failed: ' + err);

  // [adill] osx unsigned builds will fire this code signing error inside setFeedURL and
  // if we don't do anything about it hostUpdater.checkForUpdates() will never respond.
  if (err && String(err).indexOf('Could not get code signature for running application') !== -1) {
    console.warn('Skipping host updates due to code signing failure.');
    skipHostUpdate = true;
  }

  checkingForUpdates = false;
  if (!hostUpdateAvailable) {
    events.emit(UPDATE_CHECK_FINISHED, false, 0, false);
  } else {
    events.emit(DOWNLOADED_MODULE, 'host', 1, 1, false);
    events.emit(DOWNLOADING_MODULES_FINISHED, 0, 1);
  }
}

function checkForUpdates() {
  if (checkingForUpdates) return;

  checkingForUpdates = true;
  hostUpdateAvailable = false;
  if (skipHostUpdate) {
    events.emit(CHECKING_FOR_UPDATES);
    hostOnUpdateNotAvailable();
  } else {
    logger.log('Checking for host updates.');
    hostUpdater.checkForUpdates();
  }
}

function getRemoteModuleName(name) {
  if (process.platform === 'win32' && process.arch === 'x64') {
    return name + '.x64';
  }

  return name;
}

function checkForModuleUpdates() {
  var query = _extends({}, remoteQuery, { _: Math.floor(Date.now() / 1000 / 60 / 5) });
  var url = remoteBaseURL + '/versions.json';
  logger.log('Checking for module updates at ' + url);

  request.get({
    url: url,
    agent: false,
    encoding: null,
    qs: query,
    timeout: REQUEST_TIMEOUT,
    strictSSL: false
  }, function (err, response, body) {
    checkingForUpdates = false;

    if (!err && response.statusCode !== 200) {
      err = new Error('Non-200 response code: ' + response.statusCode);
    }

    if (err) {
      logger.log('Failed fetching module versions: ' + String(err));
      events.emit(UPDATE_CHECK_FINISHED, false, 0, false);
      return;
    }

    remoteModuleVersions = JSON.parse(body);
    if (settings.get(USE_LOCAL_MODULE_VERSIONS)) {
      try {
        remoteModuleVersions = JSON.parse(_fs2.default.readFileSync(localModuleVersionsFilePath));
        console.log('Using local module versions: ', remoteModuleVersions);
      } catch (err) {
        console.warn('Failed to parse local module versions: ', err);
      }
    }

    var updatesToDownload = [];
    var _iteratorNormalCompletion2 = true;
    var _didIteratorError2 = false;
    var _iteratorError2 = undefined;

    try {
      for (var _iterator2 = Object.keys(installedModules)[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
        var moduleName = _step2.value;

        var installedModule = installedModules[moduleName];
        var installed = installedModule.installedVersion;
        if (installed === null) {
          continue;
        }

        var update = installedModule.updateVersion || 0;
        var remote = remoteModuleVersions[getRemoteModuleName(moduleName)] || 0;
        // TODO: strict equality?
        if (installed != remote && update != remote) {
          logger.log('Module update available: ' + moduleName + '@' + remote + ' [installed: ' + installed + ']');
          updatesToDownload.push({ name: moduleName, version: remote });
        }
      }
    } catch (err) {
      _didIteratorError2 = true;
      _iteratorError2 = err;
    } finally {
      try {
        if (!_iteratorNormalCompletion2 && _iterator2.return) {
          _iterator2.return();
        }
      } finally {
        if (_didIteratorError2) {
          throw _iteratorError2;
        }
      }
    }

    events.emit(UPDATE_CHECK_FINISHED, true, updatesToDownload.length, false);
    if (updatesToDownload.length === 0) {
      logger.log('No module updates available.');
    } else {
      updatesToDownload.forEach(function (e) {
        return addModuleToDownloadQueue(e.name, e.version);
      });
    }
  });
}

function addModuleToDownloadQueue(name, version) {
  download.queue.push({ name: name, version: version });
  process.nextTick(function () {
    return processDownloadQueue();
  });
}

function processDownloadQueue() {
  if (download.active) return;
  if (download.queue.length === 0) return;

  download.active = true;

  var queuedModule = download.queue[download.next];
  download.next += 1;

  events.emit(DOWNLOADING_MODULE, queuedModule.name, download.next, download.queue.length);

  var totalBytes = 1;
  var receivedBytes = 0;
  var progress = 0;
  var hasErrored = false;

  var url = remoteBaseURL + '/' + getRemoteModuleName(queuedModule.name) + '/' + queuedModule.version;
  logger.log('Fetching ' + queuedModule.name + '@' + queuedModule.version + ' from ' + url);
  request.get({
    url: url,
    agent: false,
    encoding: null,
    followAllRedirects: true,
    qs: remoteQuery,
    timeout: REQUEST_TIMEOUT,
    strictSSL: false
  }).on('error', function (err) {
    if (hasErrored) return;
    hasErrored = true;
    logger.log('Failed fetching ' + queuedModule.name + '@' + queuedModule.version + ': ' + String(err));
    finishModuleDownload(queuedModule.name, queuedModule.version, null, false);
  }).on('response', function (response) {
    totalBytes = response.headers['content-length'] || 1;

    var moduleZipPath = _path2.default.join(moduleDownloadPath, queuedModule.name + '-' + queuedModule.version + '.zip');
    logger.log('Streaming ' + queuedModule.name + '@' + queuedModule.version + ' [' + totalBytes + ' bytes] to ' + moduleZipPath);

    var stream = _fs2.default.createWriteStream(moduleZipPath);
    stream.on('finish', function () {
      return finishModuleDownload(queuedModule.name, queuedModule.version, moduleZipPath, response.statusCode === 200);
    });

    response.on('data', function (chunk) {
      receivedBytes += chunk.length;
      stream.write(chunk);

      var fraction = receivedBytes / totalBytes;
      var newProgress = Math.min(Math.floor(100 * fraction), 100);
      if (progress != newProgress) {
        progress = newProgress;
        events.emit(DOWNLOADING_MODULE_PROGRESS, queuedModule.name, progress);
      }
    });

    // TODO: on response error
    // TODO: on stream error

    response.on('end', function () {
      return stream.end();
    });
  });
}

function commitInstalledModules() {
  var data = JSON.stringify(installedModules, null, 2);
  _fs2.default.writeFileSync(installedModulesFilePath, data);
}

function finishModuleDownload(name, version, zipfile, succeeded) {
  if (!installedModules[name]) {
    installedModules[name] = {};
  }

  if (succeeded) {
    installedModules[name].updateVersion = version;
    installedModules[name].updateZipfile = zipfile;
    commitInstalledModules();
  } else {
    download.failures += 1;
  }

  events.emit(DOWNLOADED_MODULE, name, download.next, download.queue.length, succeeded);

  if (download.next >= download.queue.length) {
    var successes = download.queue.length - download.failures;
    logger.log('Finished module downloads. [success: ' + successes + '] [failure: ' + download.failures + ']');
    events.emit(DOWNLOADING_MODULES_FINISHED, successes, download.failures);
    download.queue = [];
    download.next = 0;
    download.failures = 0;
    download.active = false;
  } else {
    var continueDownloads = function continueDownloads() {
      download.active = false;
      processDownloadQueue();
    };

    if (succeeded) {
      backoff.succeed();
      process.nextTick(continueDownloads);
    } else {
      logger.log('Waiting ' + Math.floor(backoff.current) + 'ms before next download.');
      backoff.fail(continueDownloads);
    }
  }

  if (newInstallInProgress[name]) {
    addModuleToUnzipQueue(name, version, zipfile);
  }
}

function addModuleToUnzipQueue(name, version, zipfile) {
  unzip.queue.push({ name: name, version: version, zipfile: zipfile });
  process.nextTick(function () {
    return processUnzipQueue();
  });
}

function processUnzipQueue() {
  if (unzip.active) return;
  if (unzip.queue.length === 0) return;

  unzip.active = true;

  var queuedModule = unzip.queue[unzip.next];
  unzip.next += 1;

  events.emit(INSTALLING_MODULE, queuedModule.name, unzip.next, unzip.queue.length);

  var hasErrored = false;
  var onError = function onError(error, zipfile) {
    if (hasErrored) return;
    hasErrored = true;

    logger.log('Failed installing ' + queuedModule.name + '@' + queuedModule.version + ': ' + String(error));
    succeeded = false;
    if (zipfile) {
      zipfile.close();
    }
    finishModuleUnzip(queuedModule, succeeded);
  };

  var succeeded = true;
  var extractRoot = _path2.default.join(moduleInstallPath, queuedModule.name);
  logger.log('Installing ' + queuedModule.name + '@' + queuedModule.version + ' from ' + queuedModule.zipfile);

  var processZipfile = function processZipfile(err, zipfile) {
    if (err) {
      onError(err, null);
      return;
    }

    var totalEntries = zipfile.entryCount;
    var processedEntries = 0;

    zipfile.on('entry', function (entry) {
      processedEntries += 1;
      var percent = Math.min(Math.floor(processedEntries / totalEntries * 100), 100);
      events.emit(INSTALLING_MODULE_PROGRESS, queuedModule.name, percent);

      // skip directories
      if (/\/$/.test(entry.fileName)) {
        zipfile.readEntry();
        return;
      }

      zipfile.openReadStream(entry, function (err, stream) {
        if (err) {
          onError(err, zipfile);
          return;
        }

        stream.on('error', function (e) {
          return onError(e, zipfile);
        });

        (0, _mkdirp2.default)(_path2.default.join(extractRoot, _path2.default.dirname(entry.fileName)), function (err) {
          if (err) {
            onError(err, zipfile);
            return;
          }

          var writeStream = originalFs.createWriteStream(_path2.default.join(extractRoot, entry.fileName));

          writeStream.on('error', function (e) {
            stream.destroy();
            onError(e, zipfile);
          });

          writeStream.on('finish', function () {
            return zipfile.readEntry();
          });

          stream.pipe(writeStream);
        });
      });
    });

    zipfile.on('error', function (err) {
      onError(err, zipfile);
    });

    zipfile.on('end', function () {
      if (!succeeded) return;

      installedModules[queuedModule.name].installedVersion = queuedModule.version;
      finishModuleUnzip(queuedModule, succeeded);
    });

    zipfile.readEntry();
  };

  try {
    _yauzl2.default.open(queuedModule.zipfile, { lazyEntries: true, autoClose: true }, processZipfile);
  } catch (err) {
    onError(err, null);
  }
}

function finishModuleUnzip(unzippedModule, succeeded) {
  delete newInstallInProgress[unzippedModule.name];
  delete installedModules[unzippedModule.name].updateZipfile;
  delete installedModules[unzippedModule.name].updateVersion;
  commitInstalledModules();

  if (!succeeded) {
    unzip.failures += 1;
  }

  events.emit(INSTALLED_MODULE, unzippedModule.name, unzip.next, unzip.queue.length, succeeded);

  if (unzip.next >= unzip.queue.length) {
    var successes = unzip.queue.length - unzip.failures;
    bootstrapping = false;
    logger.log('Finished module installations. [success: ' + successes + '] [failure: ' + unzip.failures + ']');
    unzip.queue = [];
    unzip.next = 0;
    unzip.failures = 0;
    unzip.active = false;
    events.emit(INSTALLING_MODULES_FINISHED, successes, unzip.failures);
    return;
  }

  process.nextTick(function () {
    unzip.active = false;
    processUnzipQueue();
  });
}

function quitAndInstallUpdates() {
  if (__SDK__) return;

  logger.log('Relaunching to install ' + (hostUpdateAvailable ? 'host' : 'module') + ' updates...');
  if (hostUpdateAvailable) {
    hostUpdater.quitAndInstall();
  } else {
    relaunch();
  }
}

function relaunch() {
  logger.end();

  var _require = require('electron'),
      app = _require.app;

  app.relaunch();
  app.quit();
}

function isInstalled(name) {
  var metadata = installedModules[name];
  return metadata && metadata.installedVersion > 0 || locallyInstalledModules;
}

function getInstalled() {
  return _extends({}, installedModules);
}

function install(name, defer) {
  if (isInstalled(name)) {
    if (!defer) {
      events.emit(INSTALLED_MODULE, name, 1, 1, true);
    }
    return;
  }

  if (newInstallInProgress[name]) return;

  if (!updatable) {
    logger.log('Not updatable; ignoring request to install ' + name + '...');
    return;
  }

  if (defer) {
    logger.log('Deferred install for ' + name + '...');
    installedModules[name] = { installedVersion: 0 };
    commitInstalledModules();
  } else {
    logger.log('Starting to install ' + name + '...');
    var version = remoteModuleVersions[name] || 0;
    newInstallInProgress[name] = version;
    addModuleToDownloadQueue(name, version);
  }
}

function installPendingUpdates() {
  var updatesToInstall = [];

  if (bootstrapping) {
    var modules = {};
    try {
      modules = JSON.parse(_fs2.default.readFileSync(bootstrapManifestFilePath));
    } catch (err) {}

    var _iteratorNormalCompletion3 = true;
    var _didIteratorError3 = false;
    var _iteratorError3 = undefined;

    try {
      for (var _iterator3 = Object.keys(modules)[Symbol.iterator](), _step3; !(_iteratorNormalCompletion3 = (_step3 = _iterator3.next()).done); _iteratorNormalCompletion3 = true) {
        var moduleName = _step3.value;

        installedModules[moduleName] = { installedVersion: 0 };
        var zipfile = _path2.default.join(paths.getResources(), 'bootstrap', moduleName + '.zip');
        updatesToInstall.push({ moduleName: moduleName, update: modules[moduleName], zipfile: zipfile });
      }
    } catch (err) {
      _didIteratorError3 = true;
      _iteratorError3 = err;
    } finally {
      try {
        if (!_iteratorNormalCompletion3 && _iterator3.return) {
          _iterator3.return();
        }
      } finally {
        if (_didIteratorError3) {
          throw _iteratorError3;
        }
      }
    }
  }

  var _iteratorNormalCompletion4 = true;
  var _didIteratorError4 = false;
  var _iteratorError4 = undefined;

  try {
    for (var _iterator4 = Object.keys(installedModules)[Symbol.iterator](), _step4; !(_iteratorNormalCompletion4 = (_step4 = _iterator4.next()).done); _iteratorNormalCompletion4 = true) {
      var _moduleName = _step4.value;

      var update = installedModules[_moduleName].updateVersion || 0;
      var _zipfile = installedModules[_moduleName].updateZipfile;
      if (update > 0 && _zipfile != null) {
        updatesToInstall.push({ moduleName: _moduleName, update: update, zipfile: _zipfile });
      }
    }
  } catch (err) {
    _didIteratorError4 = true;
    _iteratorError4 = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion4 && _iterator4.return) {
        _iterator4.return();
      }
    } finally {
      if (_didIteratorError4) {
        throw _iteratorError4;
      }
    }
  }

  if (updatesToInstall.length > 0) {
    logger.log((bootstrapping ? 'Bootstrapping' : 'Installing updates') + '...');
    updatesToInstall.forEach(function (e) {
      return addModuleToUnzipQueue(e.moduleName, e.update, e.zipfile);
    });
  } else {
    logger.log('No updates to install');
    events.emit(NO_PENDING_UPDATES);
  }
}