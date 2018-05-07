const VoiceEngine = require('./discord_voice.node');
const ChildProcess = require('child_process');
const path = require('path');

const isElectronRenderer =
  typeof window !== 'undefined' && window != null && window.DiscordNative && window.DiscordNative.isRenderer;

const appSettings = isElectronRenderer ? require('electron').remote.getGlobal('appSettings') : global.appSettings;
const features = isElectronRenderer ? require('electron').remote.getGlobal('features') : global.features;
const mainArgv = isElectronRenderer ? require('electron').remote.process.argv : [];
const releaseChannel = isElectronRenderer ? require('electron').remote.getGlobal('releaseChannel') : '';
const modulePath = isElectronRenderer ? require('electron').remote.getGlobal('modulePath') : '';

const useLegacyAudioDevice = appSettings ? appSettings.get('useLegacyAudioDevice') : false;
const debugLogging = appSettings ? appSettings.get('debugLogging') : false;
const logToStderr = mainArgv.slice(1).includes('--log-to-stderr');
const logVerbose = mainArgv.slice(1).includes('--log-verbose');

let voiceModulePath;
if (debugLogging && modulePath) {
  voiceModulePath = path.join(modulePath, 'discord_voice');
}

features.declareSupported('voice_panning');
features.declareSupported('voice_multiple_connections');
features.declareSupported('media_devices');
features.declareSupported('media_video');
features.declareSupported('debug_logging');

if (process.platform === 'win32') {
  features.declareSupported('voice_legacy_subsystem');
  features.declareSupported('soundshare');
}

VoiceEngine.createTransport = VoiceEngine._createTransport;

if (isElectronRenderer) {
  VoiceEngine.setImageDataAllocator((width, height) => new window.ImageData(width, height));
}

VoiceEngine.setUseLegacyAudioDevice = function(useLegacyAudioDevice_) {
  if (appSettings == null) {
    console.warn('Unable to access app settings.');
    return;
  }

  if (useLegacyAudioDevice === useLegacyAudioDevice_) {
    return;
  }

  appSettings.set('useLegacyAudioDevice', useLegacyAudioDevice_);
  appSettings.save();

  reloadElectronApp();
};

VoiceEngine.getUseLegacyAudioDevice = function() {
  return useLegacyAudioDevice;
};

VoiceEngine.setDebugLogging = function(enable) {
  if (appSettings == null) {
    console.warn('Unable to access app settings.');
    return;
  }

  if (debugLogging === enable) {
    return;
  }

  appSettings.set('debugLogging', enable);

  appSettings.save();
  reloadElectronApp();
};

VoiceEngine.getDebugLogging = function() {
  return debugLogging;
};

reloadElectronApp = function() {
  if (isElectronRenderer) {
    const app = require('electron').remote.app;
    app.relaunch();
    app.exit(0);
  } else {
    ChildProcess.spawn(process.argv[0], process.argv.splice(1), {detached: true});
    process.exit(0);
  }
};

console.log(`Initializing voice engine [legacy device: ${useLegacyAudioDevice}]`);
VoiceEngine.initialize({useLegacyAudioDevice, logToStderr, logVerbose, voiceModulePath});

module.exports = VoiceEngine;
