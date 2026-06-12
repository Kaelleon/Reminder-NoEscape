import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/ui/screens/alert_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:reminder_noescape/models/task_view_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Notificaciones de repetición usan un offset de id para no chocar
  // con el id principal de la tarea.
  static const int _repeatIdOffset = 1000000;

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        _navigateToAlert(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: _onNotificationTapBackground,
    );

    await _createNotificationChannel();

    const MethodChannel('reminder_noescape/alert')
        .setMethodCallHandler((call) async {
      if (call.method == 'showAlert') {
        _navigateToAlert(call.arguments as String?);
      }
    });
  }

  // ── Callbacks tap ────────────────────────────────────────────────────────

  @pragma('vm:entry-point')
  static void _onNotificationTapBackground(NotificationResponse response) {
    _navigateToAlert(response.payload);
  }

  static void _navigateToAlert(String? payload) {
  if (payload == null) return;
  Future.delayed(const Duration(milliseconds: 500), () {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    final task = taskVM.findById(payload);
    if (task == null) return;

    // ✅ Cancela la repetición porque el usuario SÍ respondió
    cancelRepeatNotification(task);

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AlertScreen(task: task),
        settings: const RouteSettings(name: AlertScreen.routeName),
      ),
    );
  });
}

  // ── Canal ────────────────────────────────────────────────────────────────
  //
  // El ID del canal depende del sonido elegido, ya que Android no permite
  // cambiar el sonido de un canal existente (canales inmutables).

  static String _channelId() {
    final sound = StorageService.loadAlertSound();
    return 'reminder_channel_$sound';
  }

  static Future<void> _createNotificationChannel() async {
    final soundSetting = StorageService.loadAlertSound();
    final customPath = StorageService.loadCustomSoundPath();

    AndroidNotificationSound? sound;
    if (soundSetting == 'custom' && customPath != null && customPath.isNotEmpty) {
      sound = UriAndroidNotificationSound(customPath);
    } else if (soundSetting != 'default' && soundSetting != 'silent') {
      // Requiere archivo en android/app/src/main/res/raw/<soundSetting>.mp3
      sound = RawResourceAndroidNotificationSound(soundSetting);
    }

    final channel = AndroidNotificationChannel(
      _channelId(),
      'Recordatorios',
      description: 'Notificaciones insistentes de recordatorios',
      importance: Importance.max,
      playSound: soundSetting != 'silent',
      sound: sound,
    );

    await AndroidFlutterLocalNotificationsPlugin()
        .createNotificationChannel(channel);
  }

  static AndroidNotificationDetails _androidDetails() {
    return AndroidNotificationDetails(
      _channelId(),
      'Recordatorios',
      channelDescription: 'Notificaciones insistentes de recordatorios',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
      visibility: NotificationVisibility.public,
    );
  }

  // ── API pública ──────────────────────────────────────────────────────────

  static Future<void> showTestNotification(Task task) async {
    await _createNotificationChannel();
    await _plugin.show(
      id: task.id.hashCode,
      title: '🔔 ${task.title}',
      body: task.description.isNotEmpty
          ? task.description
          : 'Tienes una tarea pendiente',
      notificationDetails: NotificationDetails(android: _androidDetails()),
      payload: task.id,
    );
  }

static Future<void> scheduleTaskNotification(Task task) async {
  await _createNotificationChannel();

  final scheduledTime = tz.TZDateTime.from(task.anticipationTime, tz.local);

  // Notificación principal
  await _plugin.zonedSchedule(
    id: task.id.hashCode,
    title: '⏰ ${task.title}',
    body: task.description.isNotEmpty
        ? task.description
        : 'Tienes una tarea pendiente',
    scheduledDate: scheduledTime,
    notificationDetails: NotificationDetails(android: _androidDetails()),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: task.id,
  );

  // Una sola repetición tras el intervalo del usuario
  await _plugin.zonedSchedule(
    id: task.id.hashCode + _repeatIdOffset,
    title: '🔁 ${task.title}',
    body: 'Sigue pendiente',
    scheduledDate: scheduledTime.add(task.reminderInterval),
    notificationDetails: NotificationDetails(android: _androidDetails()),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: task.id,
  );
}

// Nuevo método: programa la SIGUIENTE repetición tras el intervalo
// Se llama desde el BroadcastReceiver cuando la notificación se dispara
// y el usuario NO la tocó todavía.
static Future<void> scheduleRepeatNotification(Task task) async {
  await _createNotificationChannel();

  final nextTime = tz.TZDateTime.now(tz.local).add(task.reminderInterval);

  await _plugin.zonedSchedule(
    id: task.id.hashCode + _repeatIdOffset,
    title: '🔁 ${task.title}',
    body: 'Sigue pendiente',
    scheduledDate: nextTime,
    notificationDetails: NotificationDetails(android: _androidDetails()),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: task.id,
  );
}

  /// Cancela la notificación de repetición a 10s (llamar al abrir AlertScreen).
  static Future<void> cancelRepeatNotification(Task task) async {
    await _plugin.cancel(id: task.id.hashCode + _repeatIdOffset);
  }

static Future<void> cancelTaskNotification(Task task) async {
  await _plugin.cancel(id: task.id.hashCode);
  await _plugin.cancel(id: task.id.hashCode + _repeatIdOffset);
}

  static Future<void> cancelAllById(String id) async {
    await _plugin.cancel(id: id.hashCode);
    await _plugin.cancel(id: id.hashCode + _repeatIdOffset);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Selección de sonido custom ─────────────────────────────────────────
  static Future<String?> pickCustomSound() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result == null || result.files.single.path == null) return null;
    return result.files.single.path;
  }

  // ── Vista previa de sonido ────────────────────────────────────────────
  static Future<void> previewSound(String soundSetting, String? customPath) async {
    if (soundSetting == 'silent') return;

    await _createNotificationChannel();

    // Usamos una notificación temporal con autoCancel para reproducir el sonido
    AndroidNotificationSound? sound;
    if (soundSetting == 'custom' && customPath != null && customPath.isNotEmpty) {
      sound = UriAndroidNotificationSound(customPath);
    } else if (soundSetting != 'default') {
      sound = RawResourceAndroidNotificationSound(soundSetting);
    }

    await _plugin.show(
      id: 888888,
      title: 'Vista previa',
      body: 'Sonido de alerta',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId(),
          'Recordatorios',
          channelDescription: 'Vista previa de sonido',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: sound,
          autoCancel: true,
          visibility: NotificationVisibility.public,
        ),
      ),
    );

    // Auto-cancelar tras 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      _plugin.cancel(id: 888888);
    });
  }
}