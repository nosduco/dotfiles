'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var electron = require('electron');
var EventEmitter = require('events');
var process = require('process');
var common = require('./_common');
var remoteMenu = electron.remote.Menu;
var webFrame = electron.webFrame;

function flashFrame(flag) {
  var currentWindow = common.getCurrentWindow();
  if (currentWindow == null || currentWindow.flashFrame == null) return;
  currentWindow.flashFrame(!currentWindow.isFocused() && flag);
}

function minimize() {
  var win = common.getCurrentWindow();
  if (win == null) return;
  win.minimize();
}

function restore() {
  var win = common.getCurrentWindow();
  if (win == null) return;
  win.restore();
}

function maximize() {
  var win = common.getCurrentWindow();
  if (win == null) return;
  if (win.isMaximized()) {
    win.unmaximize();
  } else {
    win.maximize();
  }
}

function focus(hack) {
  var win = common.getCurrentWindow();
  // Windows does not respect the focus call always.
  // This uses a hack defined in https://github.com/electron/electron/issues/2867
  // Should be used sparingly because it can effect window managers.
  if (hack && process.platform === 'win32') {
    win.setAlwaysOnTop(true);
    win.focus();
    win.setAlwaysOnTop(false);
  } else {
    win.focus();
  }
}

function fullscreen() {
  var currentWindow = common.getCurrentWindow();
  currentWindow.setFullScreen(!currentWindow.isFullScreen());
}

function close() {
  if (process.platform === 'darwin') {
    remoteMenu.sendActionToFirstResponder('hide:');
  } else {
    common.getCurrentWindow().close();
  }
}

function setZoomFactor(factor) {
  if (!webFrame.setZoomFactor) return;
  webFrame.setZoomFactor(factor / 100);
}

var webContents = common.getCurrentWindow().webContents;

var WebContents = function (_EventEmitter) {
  _inherits(WebContents, _EventEmitter);

  function WebContents() {
    _classCallCheck(this, WebContents);

    var _this = _possibleConstructorReturn(this, (WebContents.__proto__ || Object.getPrototypeOf(WebContents)).call(this));

    webContents.removeAllListeners('devtools-opened');
    webContents.on('devtools-opened', function () {
      _this.emit('devtools-opened');
    });
    return _this;
  }

  _createClass(WebContents, [{
    key: 'setBackgroundThrottling',
    value: function setBackgroundThrottling(enabled) {
      if (webContents.setBackgroundThrottling != null) {
        webContents.setBackgroundThrottling(enabled);
      }
    }
  }]);

  return WebContents;
}(EventEmitter);

module.exports = {
  flashFrame: flashFrame,
  minimize: minimize,
  restore: restore,
  maximize: maximize,
  focus: focus,
  fullscreen: fullscreen,
  close: close,
  setZoomFactor: setZoomFactor,
  webContents: new WebContents()
};