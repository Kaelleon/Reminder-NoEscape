import 'package:flutter/material.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';

class PreferencesViewModel extends ChangeNotifier {
  String _theme = StorageService.loadTheme();
  String _language = StorageService.loadLanguage();
  String _alertSound = StorageService.loadAlertSound();
  String? _customSoundPath = StorageService.loadCustomSoundPath();
  int _alertDuration = StorageService.loadAlertDuration();

  String get theme => _theme;
  String get language => _language;
  String get alertSound => _alertSound;
  String? get customSoundPath => _customSoundPath;
  int get alertDuration => _alertDuration;

  Future<void> setTheme(String value) async {
    _theme = value;
    await StorageService.saveTheme(value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await StorageService.saveLanguage(value);
    notifyListeners();
  }

  Future<void> setAlertSound(String value) async {
    _alertSound = value;
    await StorageService.saveAlertSound(value);
    notifyListeners();
  }

  Future<void> setCustomSoundPath(String value) async {
    _customSoundPath = value;
    await StorageService.saveCustomSoundPath(value);
    notifyListeners();
  }

  Future<void> setAlertDuration(int value) async {
    _alertDuration = value;
    await StorageService.saveAlertDuration(value);
    notifyListeners();
  }
}