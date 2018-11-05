'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var FeatureFlags = function () {
  function FeatureFlags() {
    _classCallCheck(this, FeatureFlags);

    this.flags = new Set();
  }

  _createClass(FeatureFlags, [{
    key: 'getSupported',
    value: function getSupported() {
      return Array.from(this.flags);
    }
  }, {
    key: 'supports',
    value: function supports(feature) {
      return this.flags.has(feature);
    }
  }, {
    key: 'declareSupported',
    value: function declareSupported(feature) {
      if (this.supports(feature)) {
        console.error('Feature redeclared; is this a duplicate flag? ', feature);
        return;
      }

      this.flags.add(feature);
    }
  }]);

  return FeatureFlags;
}();

exports.default = FeatureFlags;
module.exports = exports['default'];