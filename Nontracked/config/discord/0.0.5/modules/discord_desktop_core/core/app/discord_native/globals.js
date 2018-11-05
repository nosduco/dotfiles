'use strict';

var electron = require('electron');
var getGlobal = electron.remote.getGlobal;

module.exports = {
  get releaseChannel() {
    return getGlobal('releaseChannel');
  },
  get crashReporterMetadata() {
    return getGlobal('crashReporterMetadata');
  },
  get features() {
    return getGlobal('features');
  },
  get appSettings() {
    return getGlobal('appSettings');
  }
};