'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

// TODO: sync fs operations could cause slowdown and/or freezes, depending on usage
//       if this is fine, remove this todo
var Settings = function () {
  function Settings(root) {
    _classCallCheck(this, Settings);

    this.path = _path2.default.join(root, 'settings.json');
    try {
      this.lastSaved = _fs2.default.readFileSync(this.path);
      this.settings = JSON.parse(this.lastSaved);
    } catch (e) {
      this.lastSaved = '';
      this.settings = {};
    }
    this.lastModified = this._lastModified();
  }

  _createClass(Settings, [{
    key: '_lastModified',
    value: function _lastModified() {
      try {
        return _fs2.default.statSync(this.path).mtime.getTime();
      } catch (e) {
        return 0;
      }
    }
  }, {
    key: 'get',
    value: function get(key) {
      var defaultValue = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;

      if (this.settings.hasOwnProperty(key)) {
        return this.settings[key];
      }

      return defaultValue;
    }
  }, {
    key: 'set',
    value: function set(key, value) {
      this.settings[key] = value;
    }
  }, {
    key: 'save',
    value: function save() {
      if (this.lastModified && this.lastModified !== this._lastModified()) {
        console.warn('Not saving settings, it has been externally modified.');
        return;
      }

      try {
        var toSave = JSON.stringify(this.settings, null, 2);
        if (this.lastSaved != toSave) {
          this.lastSaved = toSave;
          _fs2.default.writeFileSync(this.path, toSave);
          this.lastModified = this._lastModified();
        }
      } catch (err) {
        console.warn('Failed saving settings with error: ', err);
      }
    }
  }]);

  return Settings;
}();

exports.default = Settings;
module.exports = exports['default'];