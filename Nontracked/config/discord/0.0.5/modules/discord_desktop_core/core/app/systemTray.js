'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.hasInit = undefined;
exports.init = init;
exports.show = show;
exports.displayHowToCloseHint = displayHowToCloseHint;

var _electron = require('electron');

var _utils = require('./utils');

var _appSettings = require('./appSettings');

var _Constants = require('./Constants');

var settings = (0, _appSettings.getSettings)();

// These are lazy loaded into temp files
var TrayIconNames = {
  DEFAULT: 'tray',
  UNREAD: 'tray-unread',
  CONNECTED: 'tray-connected',
  SPEAKING: 'tray-speaking',
  MUTED: 'tray-muted',
  DEAFENED: 'tray-deafened'
};

var MenuItems = {
  SECRET: 'SECRET',
  MUTE: 'MUTE',
  DEAFEN: 'DEAFEN',
  OPEN: 'OPEN',
  VOICE_SETTINGS: 'VOICE_SETTINGS',
  CHECK_UPDATE: 'CHECK_UPDATE',
  QUIT: 'QUIT',
  ACKNOWLEDGEMENTS: 'ACKNOWLEDGEMENTS'
};

var hasInit = exports.hasInit = false;
var currentIcon = void 0;
var options = void 0;
var menuItems = void 0;
var contextMenu = void 0;
var atomTray = void 0;
var trayIcons = void 0;

function init(_options) {
  if (hasInit) {
    console.warn('systemTray: Has already init! Cancelling init.');
    return;
  }

  trayIcons = {};
  generateTrayIconPaths();

  exports.hasInit = hasInit = true;
  options = _options;
  currentIcon = trayIcons.DEFAULT;
  menuItems = {};
  contextMenu = [];

  initializeMenuItems();
  buildContextMenu();

  _electron.ipcMain.on('SYSTEM_TRAY_SET_ICON', function (evt, icon) {
    return setTrayIcon(icon);
  });
}

function generateTrayIconPaths() {
  // Load in the icons for current platform
  var resourcePath = 'app/images/systemtray/' + process.platform;
  var suffix = process.platform === 'darwin' ? 'Template' : '';

  var _iteratorNormalCompletion = true;
  var _didIteratorError = false;
  var _iteratorError = undefined;

  try {
    for (var _iterator = Object.keys(TrayIconNames)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
      var key = _step.value;

      trayIcons[key] = (0, _utils.exposeModuleResource)(resourcePath, '' + TrayIconNames[key] + suffix + '.png');
    }
  } catch (err) {
    _didIteratorError = true;
    _iteratorError = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion && _iterator.return) {
        _iterator.return();
      }
    } finally {
      if (_didIteratorError) {
        throw _iteratorError;
      }
    }
  }
}

function initializeMenuItems() {
  var _options2 = options,
      onToggleMute = _options2.onToggleMute,
      onToggleDeafen = _options2.onToggleDeafen,
      onTrayClicked = _options2.onTrayClicked,
      onOpenVoiceSettings = _options2.onOpenVoiceSettings,
      onCheckForUpdates = _options2.onCheckForUpdates;

  var voiceConnected = currentIcon !== trayIcons.DEFAULT && currentIcon !== trayIcons.UNREAD;

  menuItems[MenuItems.SECRET] = {
    label: 'Top Secret Control Panel',
    icon: trayIcons.DEFAULT,
    enabled: false
  };
  menuItems[MenuItems.MUTE] = {
    label: 'Mute',
    type: 'checkbox',
    checked: currentIcon === trayIcons.MUTED || currentIcon === trayIcons.DEAFENED,
    visible: voiceConnected,
    click: onToggleMute
  };
  menuItems[MenuItems.DEAFEN] = {
    label: 'Deafen',
    type: 'checkbox',
    checked: currentIcon === trayIcons.DEAFENED,
    visible: voiceConnected,
    click: onToggleDeafen
  };
  menuItems[MenuItems.OPEN] = {
    label: 'Open ' + _Constants.APP_NAME,
    type: 'normal',
    visible: process.platform === 'linux',
    click: onTrayClicked
  };
  menuItems[MenuItems.VOICE_SETTINGS] = {
    label: 'Voice / Video Settings',
    type: 'normal',
    visible: voiceConnected,
    click: onOpenVoiceSettings
  };
  menuItems[MenuItems.CHECK_UPDATE] = {
    label: 'Check for Updates...',
    type: 'normal',
    visible: process.platform !== 'darwin',
    click: onCheckForUpdates
  };
  menuItems[MenuItems.QUIT] = {
    label: 'Quit ' + _Constants.APP_NAME,
    role: 'quit'
  };
  menuItems[MenuItems.ACKNOWLEDGEMENTS] = {
    label: 'Acknowledgements',
    type: 'normal',
    visible: process.platform !== 'darwin',
    click: function click() {
      return _electron.shell.openExternal('https://discordapp.com/acknowledgements');
    }
  };
}

function buildContextMenu() {
  var separator = { type: 'separator' };

  contextMenu = [menuItems[MenuItems.SECRET], separator, menuItems[MenuItems.OPEN], menuItems[MenuItems.MUTE], menuItems[MenuItems.DEAFEN], menuItems[MenuItems.VOICE_SETTINGS], menuItems[MenuItems.CHECK_UPDATE], menuItems[MenuItems.ACKNOWLEDGEMENTS], separator, menuItems[MenuItems.QUIT]];
}

function setTrayIcon(icon) {
  // Keep track of last set icon
  currentIcon = trayIcons[icon];

  // If icon is null, hide the tray icon.  Otherwise show
  // These calls also check for tray existence, so minimal cost.
  if (icon == null) {
    hide();
    return;
  } else {
    show();
  }

  // Keep mute/deafen menu items in sync with client, based on icon states
  var muteIndex = contextMenu.indexOf(menuItems[MenuItems.MUTE]);
  var deafenIndex = contextMenu.indexOf(menuItems[MenuItems.DEAFEN]);
  var voiceConnected = contextMenu[muteIndex].visible;
  var shouldSetContextMenu = false;

  if (currentIcon !== trayIcons.DEFAULT && currentIcon !== trayIcons.UNREAD) {
    // Show mute/deaf controls
    if (!voiceConnected) {
      contextMenu[muteIndex].visible = true;
      contextMenu[deafenIndex].visible = true;
      shouldSetContextMenu = true;
    }

    if (currentIcon === trayIcons.DEAFENED) {
      contextMenu[muteIndex].checked = true;
      contextMenu[deafenIndex].checked = true;
      shouldSetContextMenu = true;
    } else if (currentIcon === trayIcons.MUTED) {
      contextMenu[muteIndex].checked = true;
      contextMenu[deafenIndex].checked = false;
      shouldSetContextMenu = true;
    } else if (contextMenu[muteIndex].checked || contextMenu[deafenIndex].checked) {
      contextMenu[muteIndex].checked = false;
      contextMenu[deafenIndex].checked = false;
      shouldSetContextMenu = true;
    }
  } else if (voiceConnected) {
    contextMenu[muteIndex].visible = false;
    contextMenu[deafenIndex].visible = false;
    shouldSetContextMenu = true;
  }

  shouldSetContextMenu && setContextMenu();
  atomTray != null && atomTray.setImage(currentIcon);
}

function setContextMenu() {
  atomTray != null && atomTray.setContextMenu(_electron.Menu.buildFromTemplate(contextMenu));
}

function show() {
  if (atomTray != null) return;

  atomTray = new _electron.Tray(currentIcon); // Initialize with last set icon
  atomTray.setToolTip(_Constants.APP_NAME);

  // Set tray context menu
  setContextMenu();

  // Set Tray click behavior
  atomTray.on('click', options.onTrayClicked);
}

function hide() {
  if (atomTray == null) {
    return;
  }

  atomTray.destroy();
  atomTray = null;
}

function displayHowToCloseHint() {
  if (settings.get('trayBalloonShown') != null || atomTray == null) {
    return;
  }

  // TODO: localize
  var balloonMessage = 'Hi! Discord will run in the background to keep you in touch with your friends.' + ' You can right-click here to quit.';
  settings.set('trayBalloonShown', true);
  settings.save();
  atomTray.displayBalloon({
    title: 'Discord',
    content: balloonMessage
  });
}