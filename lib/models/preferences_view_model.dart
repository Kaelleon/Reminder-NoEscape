import 'package:flutter/material.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';

class PreferencesViewModel extends ChangeNotifier 
{
  String _theme = StorageService.loadTheme();
  String _language = StorageService.loadLanguage();
  bool _vibration = StorageService.loadVibration();
  String _vibrationIntensity = StorageService.loadVibrationIntensity();
  String _vibrationPattern = StorageService.loadVibrationPattern();
  bool _flash = StorageService.loadFlash();
  int _flashFrequency = StorageService.loadFlashFrequency();
  bool _flashOnlyScreenOff = StorageService.loadFlashOnlyScreenOff();
  String _alertSound = StorageService.loadAlertSound();
  String? _customSoundPath = StorageService.loadCustomSoundPath();
  int _alertDuration = StorageService.loadAlertDuration();

  String get theme => _theme;
  String get language => _language;
  bool get vibration => _vibration;
  String get vibrationIntensity => _vibrationIntensity;
  String get vibrationPattern => _vibrationPattern;
  bool get flash => _flash;
  int get flashFrequency => _flashFrequency;
  bool get flashOnlyScreenOff => _flashOnlyScreenOff;
  String get alertSound => _alertSound;
  String? get customSoundPath => _customSoundPath;
  int get alertDuration => _alertDuration;

  Future<void> setTheme(String value) async 
  {
    _theme = value;
    await StorageService.saveTheme(value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async 
  {
    _language = value;
    await StorageService.saveLanguage(value);
    notifyListeners();
  }

  Future<void> setVibration(bool value) async 
  {
    _vibration = value;
    await StorageService.saveVibration(value);
    notifyListeners();
  }

  Future<void> setVibrationIntensity(String value) async 
  {
    _vibrationIntensity = value;
    await StorageService.saveVibrationIntensity(value);
    notifyListeners();
  }

  Future<void> setVibrationPattern(String value) async 
  {
    _vibrationPattern = value;
    await StorageService.saveVibrationPattern(value);
    notifyListeners();
  }

  Future<void> setFlash(bool value) async 
  {
    _flash = value;
    await StorageService.saveFlash(value);
    notifyListeners();
  }

  Future<void> setFlashFrequency(int value) async 
  {
    _flashFrequency = value;
    await StorageService.saveFlashFrequency(value);
    notifyListeners();
  }

  Future<void> setFlashOnlyScreenOff(bool value) async 
  {
    _flashOnlyScreenOff = value;
    await StorageService.saveFlashOnlyScreenOff(value);
    notifyListeners();
  }

  Future<void> setAlertSound(String value) async 
  {
    _alertSound = value;
    await StorageService.saveAlertSound(value);
    notifyListeners();
  }

  Future<void> setCustomSoundPath(String value) async 
  {
    _customSoundPath = value;
    await StorageService.saveCustomSoundPath(value);
    notifyListeners();
  }

  Future<void> setAlertDuration(int value) async 
  {
    _alertDuration = value;
    await StorageService.saveAlertDuration(value);
    notifyListeners();
  }
}