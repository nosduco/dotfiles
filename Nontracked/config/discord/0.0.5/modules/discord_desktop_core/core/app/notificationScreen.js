'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.hasInit = exports.NOTIFICATION_CLICK = exports.events = undefined;

var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }(); // TODO: transparency detection?
// TODO: SHQueryUserNotificationState

exports.init = init;
exports.close = close;
exports.setMainWindow = setMainWindow;

var _electron = require('electron');

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _events = require('events');

var _url = require('url');

var _url2 = _interopRequireDefault(_url);

var _Constants = require('./Constants');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// ipcMain events
var IPC_NOTIFICATIONS_CLEAR = 'NOTIFICATIONS_CLEAR';
var IPC_NOTIFICATION_SHOW = 'NOTIFICATION_SHOW';
var IPC_NOTIFICATION_CLICK = 'NOTIFICATION_CLICK';
var IPC_NOTIFICATION_CLOSE = 'NOTIFICATION_CLOSE';

// events
var events = exports.events = new _events.EventEmitter();
var NOTIFICATION_CLICK = exports.NOTIFICATION_CLICK = 'notification-click';

var hasInit = exports.hasInit = false;
var variablesFilePath = _path2.default.join(__dirname, 'notifications', 'variables.json');

var mainWindow = void 0;
var title = void 0;
var maxVisible = void 0;
var screenPosition = void 0;
var notifications = void 0;
var hideTimeout = void 0;
var notificationWindow = void 0;
var VARIABLES = void 0;

function init(_ref) {
  var _mainWindow = _ref.mainWindow,
      _title = _ref.title,
      _maxVisible = _ref.maxVisible,
      _screenPosition = _ref.screenPosition;

  if (hasInit) {
    console.warn('notificationScreen: Has already init! Cancelling init.');
    return;
  }
  exports.hasInit = hasInit = true;

  VARIABLES = JSON.parse(_fs2.default.readFileSync(variablesFilePath));

  mainWindow = _mainWindow;

  title = _title;
  maxVisible = _maxVisible;
  screenPosition = _screenPosition;
  notifications = [];
  hideTimeout = null;

  _electron.ipcMain.on(IPC_NOTIFICATIONS_CLEAR, handleNotificationsClear);
  _electron.ipcMain.on(IPC_NOTIFICATION_SHOW, handleNotificationShow);
  _electron.ipcMain.on(IPC_NOTIFICATION_CLICK, handleNotificationClick);
  _electron.ipcMain.on(IPC_NOTIFICATION_CLOSE, handleNotificationClose);
}

function destroyWindow() {
  if (notificationWindow == null) return;

  notificationWindow.hide();
  notificationWindow.close();
  notificationWindow = null;
}

function close() {
  mainWindow = null;

  destroyWindow();

  _electron.ipcMain.removeListener(IPC_NOTIFICATIONS_CLEAR, handleNotificationsClear);
  _electron.ipcMain.removeListener(IPC_NOTIFICATION_SHOW, handleNotificationShow);
  _electron.ipcMain.removeListener(IPC_NOTIFICATION_CLICK, handleNotificationClick);
  _electron.ipcMain.removeListener(IPC_NOTIFICATION_CLOSE, handleNotificationClose);
}

function setMainWindow(_mainWindow) {
  mainWindow = _mainWindow;
}

function handleNotificationsClear() {
  notifications = [];
  updateNotifications();
}

function handleNotificationShow(e, notification) {
  notifications.push(notification);
  updateNotifications();
}

function handleNotificationClick(e, notificationId) {
  mainWindow.webContents.send(IPC_NOTIFICATION_CLICK, notificationId);
  events.emit(NOTIFICATION_CLICK);
}

function handleNotificationClose(e, notificationId) {
  if (notificationWindow) {
    notificationWindow.webContents.send('FADE_OUT', notificationId);
  }
  setTimeout(function () {
    notifications = notifications.filter(function (notification) {
      return notification.id !== notificationId;
    });
    updateNotifications();
  }, VARIABLES.outDuration);
}

function updateNotifications() {
  if (notifications.length > 0) {
    clearTimeout(hideTimeout);
    hideTimeout = null;

    if (notificationWindow != null) {
      var _calculateBoundingBox = calculateBoundingBox(),
          width = _calculateBoundingBox.width,
          height = _calculateBoundingBox.height,
          x = _calculateBoundingBox.x,
          y = _calculateBoundingBox.y;

      notificationWindow.setPosition(x, y);
      notificationWindow.setSize(width, height);
      notificationWindow.showInactive();
    } else {
      createWindow();
      return;
    }
  } else if (hideTimeout == null) {
    hideTimeout = setTimeout(function () {
      return destroyWindow();
    }, VARIABLES.outDuration * 1.1);
  }

  if (notificationWindow != null) {
    notificationWindow.webContents.send('UPDATE', notifications.slice(0, maxVisible));
  }
}

function calculateBoundingBox() {
  var _mainWindow$getPositi = mainWindow.getPosition(),
      _mainWindow$getPositi2 = _slicedToArray(_mainWindow$getPositi, 2),
      positionX = _mainWindow$getPositi2[0],
      positionY = _mainWindow$getPositi2[1];

  var _mainWindow$getSize = mainWindow.getSize(),
      _mainWindow$getSize2 = _slicedToArray(_mainWindow$getSize, 2),
      windowWidth = _mainWindow$getSize2[0],
      windowHeight = _mainWindow$getSize2[1];

  var centerPoint = {
    x: Math.round(positionX + windowWidth / 2),
    y: Math.round(positionY + windowHeight / 2)
  };

  var activeDisplay = _electron.screen.getDisplayNearestPoint(centerPoint) || _electron.screen.getPrimaryDisplay();
  var workArea = activeDisplay.workArea;

  var width = VARIABLES.width;
  //const height = (Math.min(notifications.length, maxVisible) + 1) * VARIABLES.height;
  var height = (maxVisible + 1) * VARIABLES.height;

  var x = workArea.x + workArea.width - width;
  var y = void 0;
  switch (screenPosition) {
    case 'top':
      y = workArea.y;
      break;
    case 'bottom':
      y = workArea.y + workArea.height - height;
      break;
  }

  return { x: x, y: y, width: width, height: height };
}

function createWindow() {
  if (notificationWindow != null) {
    return;
  }

  notificationWindow = new _electron.BrowserWindow({
    title: title,
    frame: false,
    resizable: false,
    show: false,
    acceptFirstMouse: true,
    alwaysOnTop: true,
    skipTaskbar: true,
    transparent: true
  });
  var notificationUrl = _url2.default.format({
    protocol: 'file',
    slashes: true,
    pathname: _path2.default.join(__dirname, 'notifications', 'index.html')
  });
  notificationWindow.loadURL(notificationUrl);
  notificationWindow.webContents.on('did-finish-load', function () {
    return updateNotifications();
  });
}