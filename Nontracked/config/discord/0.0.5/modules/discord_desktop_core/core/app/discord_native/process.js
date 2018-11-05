'use strict';

var electron = require('electron');
var process = require('process');
var remoteProcess = electron.remote.require('process');
var env = process.env;

module.exports = {
  platform: process.platform,
  env: {
    LOCALAPPDATA: env['LOCALAPPDATA'],
    'PROGRAMFILES(X86)': env['PROGRAMFILES(X86)'],
    PROGRAMFILES: env['PROGRAMFILES'],
    PROGRAMW6432: env['PROGRAMW6432'],
    PROGRAMDATA: env['PROGRAMDATA']
  },
  remote: {
    resourcesPath: remoteProcess.resourcesPath
  }
};