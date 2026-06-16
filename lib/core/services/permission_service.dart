import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';

class PermissionService {

  static Future<void> requestAll() async {
    // Notificaciones (Android 13+)
    await Permission.notification.request();

    // Alarmas exactas (Android 12+)
    final exactAlarm = await Permission.scheduleExactAlarm.status;
    if (!exactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    // Ignorar optimización de batería
    final battery = await Permission.ignoreBatteryOptimizations.status;
    if (!battery.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    // Overlay — verificación nativa más confiable
    await _requestOverlayIfNeeded();
  }

  static Future<void> _requestOverlayIfNeeded() async {
  // Si ya guardamos que lo dio, no volver a preguntar
  if (StorageService.loadOverlayGranted()) return;

  final hasOverlay = await _checkOverlayNative();
  if (hasOverlay) {
    // Ya lo tiene, guardar y no volver a preguntar
    await StorageService.saveOverlayGranted(true);
    return;
  }

  // No lo tiene — abrir ajustes
  await _requestAutoStart();
  }

  static Future<bool> _checkOverlayNative() async {
    try {
      // Usamos el status directo del plugin
      final status = await Permission.systemAlertWindow.status;
      return status == PermissionStatus.granted;
    } catch (_) {
      return false;
    }
  }

  // Intenta abrir la pantalla de autoarranque del fabricante
  static Future<void> _requestAutoStart() async {
  try {
    final overlayIntent = AndroidIntent(
      action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
      data: 'package:cl.Capi.ReminderNoEscape',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await overlayIntent.launch();
    return;
  } catch (_) {}

  // Fallback
  try {
    const fallback = AndroidIntent(
      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
      data: 'package:cl.Capi.ReminderNoEscape',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await fallback.launch();
  } catch (_) {}
}

  static Future<void> openBatterySettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  static Future<void> openAppSettings() async {
    try {
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:cl.Capi.ReminderNoEscape',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (_) {}
  }

  static Future<Map<String, bool>> checkAll() async {
    return {
      'notification': await Permission.notification.isGranted,
      'exactAlarm': await Permission.scheduleExactAlarm.isGranted,
      'battery': await Permission.ignoreBatteryOptimizations.isGranted,
      'overlay': await Permission.systemAlertWindow.isGranted,
    };
  }
}