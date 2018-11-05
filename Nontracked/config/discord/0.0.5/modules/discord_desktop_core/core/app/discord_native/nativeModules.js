'use strict';

var electron = require('electron');
var vm = require('vm');
var ipcRenderer = electron.ipcRenderer;

// Set up global module paths in renderer's require
var NodeModule = require('module');
var mainAppDirname = electron.remote.getGlobal('mainAppDirname');

var modulePaths = [];

// add native module paths
var remotePaths = electron.remote.require('module').globalPaths;
remotePaths.forEach(function (path) {
  if (!path.includes('electron.asar')) {
    modulePaths.push(path);
  }
});

// add main app module paths (limited to the discord_desktop_core .asar)
var mainAppModulePaths = NodeModule._nodeModulePaths(mainAppDirname);
modulePaths = modulePaths.concat(mainAppModulePaths.slice(0, 2));

// apply the module paths
module.paths = modulePaths;

var MODULE_INSTALL = 'MODULE_INSTALL';
var MODULE_QUERY = 'MODULE_QUERY';
var MODULE_INSTALLED = 'MODULE_INSTALLED';

var modulePromises = {};

// Handle successfully installed modules, used in ensureModule
ipcRenderer.on(MODULE_INSTALLED, function (e, name, success) {
  var promise = modulePromises[name];

  if (promise == null || promise.callback == null) {
    return;
  }

  promise.callback(success);
});

function ensureModule(name) {
  var modulePromise = modulePromises[name];
  if (modulePromise == null) {
    modulePromise = modulePromises[name] = {};
    modulePromise.promise = new Promise(function (resolve, reject) {
      modulePromise.callback = function (success) {
        modulePromise.callback = null;
        success ? resolve() : reject(new Error('failed to ensure module'));
      };

      installModule(name);
    });
  }

  return modulePromise.promise;
}

function installModule(name) {
  ipcRenderer.send(MODULE_INSTALL, name);
}

function queryModule(name) {
  ipcRenderer.send(MODULE_QUERY, name);
}

// sandbox this function in a new context, else it's susceptible to prototype attacks
var context = vm.createContext(Object.create(null));
var _requireModule = vm.runInContext('\n  function requireModule(remoteRequire, localRequire, name, remote) {\n    if (!/^discord_/.test(name) && name !== \'erlpack\') {\n      throw new Error(\'"\' + String(name) + \'" is not a whitelisted native module\');\n    }\n    return remote ? remoteRequire(name) : localRequire(name);\n  }\n  requireModule\n', context);

var remoteRequire = electron.remote.require;
var localRequire = require;

function requireModule(name, remote) {
  return _requireModule(remoteRequire, localRequire, name, remote);
}

module.exports = {
  installModule: installModule,
  queryModule: queryModule,
  ensureModule: ensureModule,
  requireModule: requireModule
};