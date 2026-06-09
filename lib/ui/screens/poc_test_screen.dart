import 'package:flutter/material.dart';
import 'package:reminder_noescape/core/services/background_service.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:reminder_noescape/core/services/permission_service.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocTestScreen extends StatefulWidget
{
  const PocTestScreen({super.key});

  @override
  State<PocTestScreen> createState() => _PocTestScreenState();
}

class _PocTestScreenState extends State<PocTestScreen>
{
  String _output = 'Resultado aparecerá aquí...';

  void _log(String msg)
  {
    final time = DateTime.now().toString().substring(11, 19);
    setState(() => _output = '[$time] $msg\n$_output');
  }

  Future<void> _solicitarPermisos() async
  {
    _log('Solicitando permisos...');
    await PermissionService.requestAll();
    final result = await PermissionService.checkAll();
    result.forEach((k, v) => _log('$k: ${v ? "✅" : "❌"}'));
  }

  Future<void> _e1Foreground() async
  {
    _log('E1: Disparando notificación inmediata...');
    await NotificationService.showTestNotification();
    _log('E1: OK — notificación enviada');
  }

  Future<void> _e2Background() async
  {
    _log('E2: Programando notificación en 30s...');
    final task = Task
    (
      title: 'PoC Test',
      description: 'Notificación en background',
      dueDate: DateTime.now().add(const Duration(minutes: 1)),
      anticipationTime: DateTime.now().add(const Duration(seconds: 30)),
      reminderInterval: const Duration(seconds: 30),
    );
    await NotificationService.scheduleTaskNotification(task);
    _log('E2: OK — envía la app al background y espera');
  }

  Future<void> _e3WorkManager() async
  {
    _log('E3: Registrando WorkManager...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pending_tasks', ['Tarea PoC']);
    await BackgroundService.registerRescueTask();
    _log('E3: OK — cierra la app forzosamente y espera máx 15 min');
  }

  Future<void> _e4DozeMode() async
  {
    _log('E4: Simular Doze Mode con ADB:');
    _log('  → adb shell dumpsys deviceidle force-idle');
    _log('  → adb shell dumpsys deviceidle unforce (para salir)');
  }

  Future<void> _e5Bateria() async
  {
    _log('E5: Abriendo config de batería...');
    await PermissionService.openBatterySettings();
    _log('E5: Busca la app → Sin restricciones');
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: const Text('PoC — Notificaciones Background')),
      body: Padding
      (
        padding: const EdgeInsets.all(16),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
          [
            ElevatedButton(onPressed: _solicitarPermisos, child: const Text('Solicitar permisos')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _e1Foreground, child: const Text('E1: Notificación inmediata')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _e2Background, child: const Text('E2: Notificación en 30s (background)')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _e3WorkManager, child: const Text('E3: WorkManager rescue task')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _e4DozeMode, child: const Text('E4: Instrucciones Doze Mode')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _e5Bateria, child: const Text('E5: Config batería ColorOS')),
            const SizedBox(height: 16),
            const Text('Log:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded
            (
              child: SingleChildScrollView
              (
                child: Text
                (
                  _output,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}