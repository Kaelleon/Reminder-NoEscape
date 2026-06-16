import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  //SONIDO DE ALERTA//
  static String loadAlertSound() => _prefs.getString('alert_sound') ?? 'default';
  static Future<void> saveAlertSound(String value) async => await _prefs.setString('alert_sound', value);

  //SONIDO PERSONALIZADO//
  static String? loadCustomSoundPath() => _prefs.getString('custom_sound_path');
  static Future<void> saveCustomSoundPath(String value) async => await _prefs.setString('custom_sound_path', value);

  //DURACION DE ALERTA//
  static int loadAlertDuration() => _prefs.getInt('alert_duration') ?? 5;
  static Future<void> saveAlertDuration(int value) async => await _prefs.setInt('alert_duration', value);

  static bool loadOverlayGranted() => _prefs.getBool('overlay_granted') ?? false;
  static Future<void> saveOverlayGranted(bool value) async =>
    await _prefs.setBool('overlay_granted', value);

  static List<Map<String, dynamic>> loadPendingTasks() {
    final raw = _prefs.getStringList('pending_tasks_data') ?? [];
    return raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  static Future<void> savePendingTasks(List<Map<String, dynamic>> tasks) async {
    final raw = tasks.map((t) => jsonEncode(t)).toList();
    await _prefs.setStringList('pending_tasks_data', raw);
  }

  static List<Map<String, dynamic>> loadHistoryTasks() {
    final raw = _prefs.getStringList('history_tasks_data') ?? [];
    return raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  static Future<void> saveHistoryTasks(List<Map<String, dynamic>> tasks) async {
    final raw = tasks.map((t) => jsonEncode(t)).toList();
    await _prefs.setStringList('history_tasks_data', raw);
  }

  //PERFIL//
  static String loadProfileName() => _prefs.getString('profile_name') ?? '';
  static Future<void> saveProfileName(String value) async => await _prefs.setString('profile_name', value);

  static String loadProfileImagePath() => _prefs.getString('profile_image_path') ?? '';
  static Future<void> saveProfileImagePath(String value) async => await _prefs.setString('profile_image_path', value);

  static String loadMemberSince() => _prefs.getString('member_since') ?? '';
  static Future<void> saveMemberSince(String value) async => await _prefs.setString('member_since', value);
}