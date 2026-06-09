import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService 
{
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async
  {
    //inicializar las zonas horarias
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: initSettings);

    //creacion de canal de notificaciones necesario en android 8+
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async
  {
    const channel = AndroidNotificationChannel
    (
      'reminder_channel',
      'Recordatorios',
      description: 'Notificaciones insistentes de recordatorios',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,

    );

    await AndroidFlutterLocalNotificationsPlugin()
    .createNotificationChannel(channel);
  }

  static AndroidNotificationDetails get _androidDetails =>
  const AndroidNotificationDetails
  (
    'reminder_channel',
    'Recordatorios',
    channelDescription: 'Notificaciones insistentes de recordatorios',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    ongoing: true,
    autoCancel: false,
    enableVibration: true,
    playSound: true,
    visibility: NotificationVisibility.public,
    category: AndroidNotificationCategory.alarm,
  );
  
  //notificacion inmediata para pruebas en el escenario 1
  static Future<void> showTestNotification() async
  {
    await _plugin.show
    (
      id: 0,
      title: '🔔 Prueba PoC — Foreground',
      body: 'Notificación disparada correctamente en foreground',
      notificationDetails: NotificationDetails(android: _androidDetails),
    );
  }

  //notificacion programada para el escenarios 2 y 4
  static Future<void> scheduleTaskNotification(Task task) async
  {
    final scheduledTime = tz.TZDateTime.from(
      task.anticipationTime,
      tz.local,
    );

    await _plugin.zonedSchedule
    (
      id: task.title.hashCode,
      title: '⏰ ${task.title}',
      body: task.description.isNotEmpty
          ? task.description
          : 'Tienes una tarea pendiente',
      scheduledDate:  scheduledTime,
      notificationDetails: NotificationDetails(android: _androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelTaskNotification(Task task) async
  {
    await _plugin.cancel(id: task.title.hashCode);
  }

  static Future<void> cancelAll() async
  {
    await _plugin.cancelAll();
  }
}