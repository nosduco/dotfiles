'use strict';

// Private utilities for discordNativeAPI.
// Don't expose to the public DiscordNative.

var electron = require('electron');

function getCurrentWindow() {
  return electron.remote.getCurrentWindow();
}

module.exports = {
  getCurrentWindow: getCurrentWindow
};