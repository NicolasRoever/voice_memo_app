//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import app_links
import audio_session
import just_audio
import path_provider_foundation
import record_darwin
import shared_preferences_foundation
import sqflite_darwin
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AppLinksMacosPlugin.register(with: registry.registrar(forPlugin: "AppLinksMacosPlugin"))
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  JustAudioPlugin.register(with: registry.registrar(forPlugin: "JustAudioPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  RecordPlugin.register(with: registry.registrar(forPlugin: "RecordPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
