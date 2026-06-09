import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService
{
  static Future<void> requestAll() async
  {
    //notificaciones de android 13+
    await Permission.notification.request();

    //alarmas exactas de android 12+
    final exactAlarm = await Permission.scheduleExactAlarm.status;
    if (!exactAlarm.isGranted)
    {
      await Permission.scheduleExactAlarm.request();
    }

    //ignorar optimizacion de bateria
    final battery = await Permission.ignoreBatteryOptimizations.status;
    if (!battery.isGranted)
    {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  //abre configuracion de bateria
  static Future<void> openBatterySettings() async
  {
    const intent = AndroidIntent
    (
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  //abre configuracion general de la app
  static Future<void> openAppSettings() async
  {
    await openAppSettings();
  }

  static Future<Map<String, bool>> checkAll() async
  {
    return
    {
      'notification': await Permission.notification.isGranted,
      'exactAlarm': await Permission.scheduleExactAlarm.isGranted,
      'battery': await Permission.ignoreBatteryOptimizations.isGranted,
    };
  }
}