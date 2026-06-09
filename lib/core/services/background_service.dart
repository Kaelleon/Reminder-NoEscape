import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

//nivel superior — requerido por WorkManager
@pragma('vm:entry-point')
void callbackDispatcher()
{
  Workmanager().executeTask((taskName, inputData) async
  {
    try
    {
      final prefs = await SharedPreferences.getInstance();
      final pendingTasks = prefs.getStringList('pending_tasks') ?? [];

      if (pendingTasks.isNotEmpty)
      {
        final plugin = FlutterLocalNotificationsPlugin();

        const androidSettings =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        await plugin.initialize
        (
          settings: const InitializationSettings(android: androidSettings),
        );

        await plugin.show
        (
          id: 999,
          title: '⏰ Recordatorio pendiente',
          body:  'Tienes ${pendingTasks.length} tarea(s) pendiente(s) — WorkManager activo',
          notificationDetails: const NotificationDetails
          (
            android: AndroidNotificationDetails
            (
              'reminder_channel',
              'Recordatorios',
              importance: Importance.max,
              priority: Priority.high,
              fullScreenIntent: true,
              visibility: NotificationVisibility.public,
            ),
          ),
        );
      }
    }
    catch (e)
    {
      // WorkManager requiere que no se lancen excepciones no controladas
      return Future.value(false);
    }

    return Future.value(true);
  });
}

class BackgroundService
{
  static Future<void> init() async
  {
    await Workmanager().initialize(callbackDispatcher);
  }

  //tarea periódica de rescate para el escenario 3
  static Future<void> registerRescueTask() async
  {
    await Workmanager().registerPeriodicTask
    (
      'rescue_task',
      'checkPendingReminders',
      frequency: const Duration(minutes: 15),
      constraints: Constraints
      (
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 1),
    );
  }

  static Future<void> cancelAll() async
  {
    await Workmanager().cancelAll();
  }
}