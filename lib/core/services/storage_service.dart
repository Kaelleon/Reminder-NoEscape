import 'package:shared_preferences/shared_preferences.dart';

class StorageService 
{
  static late SharedPreferences _prefs;

  static Future<void> init() async 
  {
    _prefs = await SharedPreferences.getInstance();
  }

  //TEMA//
  static String loadTheme() => _prefs.getString('theme') ?? 'dark';
  static Future<void> saveTheme(String value) async => await _prefs.setString('theme', value);

  //IDIOMA//
  static String loadLanguage() => _prefs.getString('language') ?? 'es';
  static Future<void> saveLanguage(String value) async => await _prefs.setString('language', value);

  //VIBRACION//
  static bool loadVibration() => _prefs.getBool('vibration') ?? true;
  static Future<void> saveVibration(bool value) async => await _prefs.setBool('vibration', value);

  //INTENSIDAD DE VIBRACION//
  static String loadVibrationIntensity() => _prefs.getString('vibration_intensity') ?? 'normal';
  static Future<void> saveVibrationIntensity(String value) async => await _prefs.setString('vibration_intensity', value);

  //PATRON DE VIBRACION//
  static String loadVibrationPattern() => _prefs.getString('vibration_pattern') ?? 'single';
  static Future<void> saveVibrationPattern(String value) async => await _prefs.setString('vibration_pattern', value);

  //FLASH//
  static bool loadFlash() => _prefs.getBool('flash') ?? false;
  static Future<void> saveFlash(bool value) async => await _prefs.setBool('flash', value);

  //FRECUENCIA DE FLASH//
  static int loadFlashFrequency() => _prefs.getInt('flash_frequency') ?? 2;
  static Future<void> saveFlashFrequency(int value) async => await _prefs.setInt('flash_frequency', value);

  //FLASH SOLO CON PANTALLA APAGADA//
  static bool loadFlashOnlyScreenOff() => _prefs.getBool('flash_only_screen_off') ?? false;
  static Future<void> saveFlashOnlyScreenOff(bool value) async => await _prefs.setBool('flash_only_screen_off', value);

  //SONIDO DE ALERTA//
  static String loadAlertSound() => _prefs.getString('alert_sound') ?? 'default';
  static Future<void> saveAlertSound(String value) async => await _prefs.setString('alert_sound', value);

  //SONIDO PERSONALIZADO//
  static String? loadCustomSoundPath() => _prefs.getString('custom_sound_path');
  static Future<void> saveCustomSoundPath(String value) async => await _prefs.setString('custom_sound_path', value);

  //DURACION DE ALERTA//
  static int loadAlertDuration() => _prefs.getInt('alert_duration') ?? 30;
  static Future<void> saveAlertDuration(int value) async => await _prefs.setInt('alert_duration', value);
}