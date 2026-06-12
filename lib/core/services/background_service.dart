import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final pendingRaw = prefs.getStringList('pending_tasks_data') ?? [];
      final historyRaw = prefs.getStringList('history_tasks_data') ?? [];

      final pending = pendingRaw
          .map((s) => jsonDecode(s) as Map<String, dynamic>)
          .toList();
      final history = historyRaw
          .map((s) => jsonDecode(s) as Map<String, dynamic>)
          .toList();

      final now = DateTime.now();
      final stillPending = <Map<String, dynamic>>[];

      for (final task in pending) {
        final dueDate = DateTime.parse(task['dueDate'] as String);
        if (dueDate.isBefore(now)) {
          task['isCompleted'] = false;
          history.add(task);
          await NotificationService.cancelAllById(task['id'] as String);
        } else {
          stillPending.add(task);
        }
      }

      await prefs.setStringList(
          'pending_tasks_data', stillPending.map((t) => jsonEncode(t)).toList());
      await prefs.setStringList(
          'history_tasks_data', history.map((t) => jsonEncode(t)).toList());

      if (stillPending.isNotEmpty) {
        final plugin = FlutterLocalNotificationsPlugin();

        const androidSettings =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        await plugin.initialize(
          settings: const InitializationSettings(android: androidSettings),
        );

        await plugin.show(
          id: 999,
          title: '⏰ Recordatorio pendiente',
          body:
              'Tienes ${stillPending.length} tarea(s) pendiente(s) — WorkManager activo',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
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
    } catch (e) {
      return Future.value(false);
    }

    return Future.value(true);
  });
}

class BackgroundService {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerRescueTask() async {
    await Workmanager().registerPeriodicTask(
      'rescue_task',
      'checkPendingReminders',
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
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

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}