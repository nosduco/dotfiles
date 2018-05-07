'use strict';

var electron = require('electron');
var remote = electron.remote;

function copy(text) {
  if (text) {
    remote.clipboard.writeText(text);
  } else {
    remote.getCurrentWebContents().copy();
  }
}

function cut() {
  remote.getCurrentWebContents().cut();
}

function paste() {
  remote.getCurrentWebContents().paste();
}

module.exports = {
  copy: copy,
  cut: cut,
  paste: paste
};