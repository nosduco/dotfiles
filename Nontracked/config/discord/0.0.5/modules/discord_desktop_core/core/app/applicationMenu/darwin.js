'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _electron = require('electron');

var _Constants = require('../Constants');

var Constants = _interopRequireWildcard(_Constants);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

var MenuEvents = Constants.MenuEvents;

var SEPARATOR = { type: 'separator' };

function getWindow() {
  var window = _electron.BrowserWindow.getFocusedWindow();
  if (!window) {
    var windowList = _electron.BrowserWindow.getAllWindows();
    if (windowList && windowList[0]) {
      window = windowList[0];
      window.show();
      window.focus();
    }
  }
  return window;
}

exports.default = [{
  label: 'Discord',
  submenu: [{
    label: 'About Discord',
    selector: 'orderFrontStandardAboutPanel:'
  }, {
    label: 'Check for Updates...',
    click: function click() {
      return _electron.app.emit(MenuEvents.CHECK_FOR_UPDATES);
    }
  }, {
    label: 'Acknowledgements',
    click: function click() {
      return _electron.shell.openExternal('https://discordapp.com/acknowledgements');
    }
  }, SEPARATOR, {
    label: 'Preferences',
    click: function click() {
      return _electron.app.emit(MenuEvents.OPEN_SETTINGS);
    },
    accelerator: 'Command+,'
  }, SEPARATOR, {
    label: 'Services',
    submenu: []
  }, SEPARATOR, {
    label: 'Hide Discord',
    selector: 'hide:',
    accelerator: 'Command+H'
  }, {
    label: 'Hide Others',
    selector: 'hideOtherApplications:',
    accelerator: 'Command+Alt+H'
  }, {
    label: 'Show All',
    selector: 'unhideAllApplications:'
  }, SEPARATOR, {
    label: 'Quit',
    click: function click() {
      return _electron.app.quit();
    },
    accelerator: 'Command+Q'
  }]
}, {
  label: 'Edit',
  submenu: [{
    label: 'Undo',
    selector: 'undo:',
    accelerator: 'Command+Z'
  }, {
    label: 'Redo',
    selector: 'redo:',
    accelerator: 'Shift+Command+Z'
  }, SEPARATOR, {
    label: 'Cut',
    selector: 'cut:',
    accelerator: 'Command+X'
  }, {
    label: 'Copy',
    selector: 'copy:',
    accelerator: 'Command+C'
  }, {
    label: 'Paste',
    selector: 'paste:',
    accelerator: 'Command+V'
  }, {
    label: 'Select All',
    selector: 'selectAll:',
    accelerator: 'Command+A'
  }]
}, {
  label: 'View',
  submenu: [{
    label: 'Reload',
    click: function click() {
      var window = getWindow();
      if (window) {
        window.webContents.reloadIgnoringCache();
      }
    },
    accelerator: 'Command+R'
  }, {
    label: 'Toggle Full Screen',
    click: function click() {
      var window = getWindow();
      if (window) {
        window.setFullScreen(!window.isFullScreen());
      }
    },
    accelerator: 'Command+Control+F'
  }, SEPARATOR, {
    label: 'Developer',
    submenu: [{
      label: 'Toggle Developer Tools',
      click: function click() {
        var window = getWindow();
        if (window) {
          window.toggleDevTools();
        }
      },
      accelerator: 'Alt+Command+I'
    }]
  }]
}, {
  label: 'Window',
  submenu: [{
    label: 'Minimize',
    selector: 'performMiniaturize:',
    accelerator: 'Command+M'
  }, {
    label: 'Zoom',
    selector: 'performZoom:'
  }, {
    label: 'Close',
    accelerator: 'Command+W',
    selector: 'hide:'
  }, SEPARATOR, {
    label: 'Bring All to Front',
    selector: 'arrangeInFront:'
  }]
}, {
  label: 'Help',
  submenu: [{
    label: 'Discord Help',
    click: function click() {
      return _electron.app.emit(MenuEvents.OPEN_HELP);
    }
  }]
}];
module.exports = exports['default'];