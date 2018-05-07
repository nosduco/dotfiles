'use strict';

var electron = require('electron');
var remoteGPUSettings = electron.remote.require('./GPUSettings');

function getEnableHardwareAcceleration() {
  return remoteGPUSettings.getEnableHardwareAcceleration();
}

function setEnableHardwareAcceleration(enable) {
  remoteGPUSettings.setEnableHardwareAcceleration(enable);
}

module.exports = {
  getEnableHardwareAcceleration: getEnableHardwareAcceleration,
  setEnableHardwareAcceleration: setEnableHardwareAcceleration
};