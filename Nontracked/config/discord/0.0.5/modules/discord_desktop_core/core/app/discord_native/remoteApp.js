'use strict';

var electron = require('electron');
var remoteApp = electron.remote.app;

function getVersion() {
  return remoteApp.getVersion();
}

var allowedAppPaths = new Set(['home', 'appData', 'desktop', 'documents', 'downloads']);

function getPath(path) {
  if (!allowedAppPaths.has(path)) {
    throw new Error(path + ' is not an allowed app path');
  }
  return remoteApp.getPath(path);
}

function setBadgeCount(count) {
  remoteApp.setBadgeCount(count);
}

function dockSetBadge(badge) {
  remoteApp.dock.setBadge(badge);
}

function dockBounce(type) {
  return remoteApp.dock.bounce(type);
}

function dockCancelBounce(id) {
  remoteApp.dock.cancelBounce(id);
}

var dockAPI = void 0;
if (remoteApp.dock) {
  dockAPI = {
    setBadge: dockSetBadge,
    bounce: dockBounce,
    cancelBounce: dockCancelBounce
  };
}

module.exports = {
  getVersion: getVersion,
  getPath: getPath,
  setBadgeCount: setBadgeCount,
  dock: dockAPI
};