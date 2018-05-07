'use strict';

var electron = require('electron');
var ipcRenderer = electron.ipcRenderer;

function send(event) {
  for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    args[_key - 1] = arguments[_key];
  }

  ipcRenderer.send.apply(ipcRenderer, [event].concat(args));
}

function on(event, callback) {
  ipcRenderer.on(event, callback);
}

module.exports = {
  send: send,
  on: on
};