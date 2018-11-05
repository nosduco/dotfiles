'use strict';

var electron = require('electron');
var fs = require('fs');
var os = require('os');
var path = require('path');
var originalFs = require('original-fs');
var remoteDialog = electron.remote.dialog;

var INVALID_FILENAME_CHAR_REGEX = /[^a-zA-Z0-9-_.]/g;

function saveWithDialog(fileContents, fileName) {
  if (INVALID_FILENAME_CHAR_REGEX.test(fileName)) {
    throw new Error('fileName has invalid characters');
  }
  var defaultPath = path.join(os.homedir(), fileName);

  remoteDialog.showSaveDialog({ defaultPath: defaultPath }, function (selectedFileName) {
    selectedFileName && fs.writeFile(selectedFileName, fileContents);
  });
}

function showOpenDialog(dialogOptions) {
  return new Promise(function (resolve) {
    return remoteDialog.showOpenDialog(dialogOptions, resolve);
  });
}

function openFiles(dialogOptions, maxSize, makeFile) {
  return showOpenDialog(dialogOptions).then(function (filenames) {
    if (filenames == null) return;

    return Promise.all(filenames.map(function (filename) {
      return new Promise(function (resolve, reject) {
        originalFs.stat(filename, function (err, stats) {
          if (err) return reject(err);

          if (stats.size > maxSize) {
            var _err = new Error('upload too large');
            // used to help determine why openFiles failed
            _err.code = 'ETOOLARGE';
            return reject(_err);
          }

          originalFs.readFile(filename, function (err, data) {
            if (err) return reject(err);
            return resolve(makeFile(data.buffer, path.basename(filename)));
          });
        });
      });
    }));
  });
}

module.exports = {
  saveWithDialog: saveWithDialog,
  openFiles: openFiles,
  showOpenDialog: showOpenDialog
};