'use strict';

// before we can set up (and export) our constants, we first need to grab bootstrap's constants
// so we can merge them in with our constants
function init(bootstrapConstants) {
  var APP_NAME = bootstrapConstants.APP_NAME;
  var API_ENDPOINT = bootstrapConstants.API_ENDPOINT;
  var UPDATE_ENDPOINT = bootstrapConstants.UPDATE_ENDPOINT;
  var APP_ID = bootstrapConstants.APP_ID;

  var DEFAULT_MAIN_WINDOW_ID = 0;
  var MAIN_APP_DIRNAME = __dirname;

  var UpdaterEvents = {
    UPDATE_NOT_AVAILABLE: 'UPDATE_NOT_AVAILABLE',
    CHECKING_FOR_UPDATES: 'CHECKING_FOR_UPDATES',
    UPDATE_ERROR: 'UPDATE_ERROR',
    UPDATE_MANUALLY: 'UPDATE_MANUALLY',
    UPDATE_AVAILABLE: 'UPDATE_AVAILABLE',
    MODULE_INSTALL_PROGRESS: 'MODULE_INSTALL_PROGRESS',
    UPDATE_DOWNLOADED: 'UPDATE_DOWNLOADED',
    MODULE_INSTALLED: 'MODULE_INSTALLED',
    CHECK_FOR_UPDATES: 'CHECK_FOR_UPDATES',
    QUIT_AND_INSTALL: 'QUIT_AND_INSTALL',
    MODULE_INSTALL: 'MODULE_INSTALL',
    MODULE_QUERY: 'MODULE_QUERY'
  };

  var MenuEvents = {
    OPEN_HELP: 'menu:open-help',
    OPEN_SETTINGS: 'menu:open-settings',
    CHECK_FOR_UPDATES: 'menu:check-for-updates'
  };

  var exported = {
    APP_NAME: APP_NAME,
    DEFAULT_MAIN_WINDOW_ID: DEFAULT_MAIN_WINDOW_ID,
    MAIN_APP_DIRNAME: MAIN_APP_DIRNAME,
    APP_ID: APP_ID,
    API_ENDPOINT: API_ENDPOINT,
    UPDATE_ENDPOINT: UPDATE_ENDPOINT,
    UpdaterEvents: UpdaterEvents,
    MenuEvents: MenuEvents
  };

  var _iteratorNormalCompletion = true;
  var _didIteratorError = false;
  var _iteratorError = undefined;

  try {
    for (var _iterator = Object.keys(exported)[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
      var key = _step.value;

      module.exports[key] = exported[key];
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

module.exports = {
  init: init
};