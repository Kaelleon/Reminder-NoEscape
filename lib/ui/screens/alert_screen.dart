import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/models/task_view_model.dart';

class AlertScreen extends StatefulWidget {
  final Task task;
  const AlertScreen({super.key, required this.task});
  static const routeName = '/alert';

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>
    with SingleTickerProviderStateMixin {
 

  late int _secondsLeft;
  bool _canExit = false;
  Timer? _countdownTimer;
  bool _actionTaken = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _secondsLeft = StorageService.loadAlertDuration();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Cancela la notificación de repetición a los 10s: el usuario ya entró.
    NotificationService.cancelRepeatNotification(widget.task);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _secondsLeft = 0;
          _canExit = true;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  // ── Botón 1: Completar ───────────────────────────────────────────────────
  void _onComplete() {
    if (!_canExit) return;
    _actionTaken = true;
    NotificationService.cancelTaskNotification(widget.task);
    context.read<TaskViewModel>().completeTask(widget.task);
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  // ── Botón 2: Realizando tarea (pausa 30 min) ─────────────────────────────
  void _onDoingTask() {
    if (!_canExit) return;
    _actionTaken = true;
    NotificationService.cancelTaskNotification(widget.task);
    final pausedTask = Task(
      id: widget.task.id,
      title: widget.task.title,
      description: widget.task.description,
      dueDate: widget.task.dueDate,
      anticipationTime: DateTime.now().add(const Duration(minutes: 30)),
      reminderInterval: widget.task.reminderInterval,
    );
    NotificationService.scheduleTaskNotification(pausedTask);
    context.read<TaskViewModel>().updateTask(pausedTask);
    Navigator.of(context).pop();
  }

  // ── Botón 3: Posponer (usa intervalo del usuario) ─────────────────────────
  void _onPostpone() {
    if (!_canExit) return;
    _actionTaken = true;
    NotificationService.cancelTaskNotification(widget.task);
    final postponedTask = Task(
      id: widget.task.id,
      title: widget.task.title,
      description: widget.task.description,
      dueDate: widget.task.dueDate,
      anticipationTime: DateTime.now().add(widget.task.reminderInterval),
      reminderInterval: widget.task.reminderInterval,
    );
    NotificationService.scheduleTaskNotification(postponedTask);
    context.read<TaskViewModel>().updateTask(postponedTask);
    Navigator.of(context).pop();
  }

  void _showLockedSnackBar() {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Espera $_secondsLeft s para poder salir',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: colors.error,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final task = widget.task;

    return PopScope(
      canPop: _canExit,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          HapticFeedback.mediumImpact();
          _showLockedSnackBar();
        } else if (didPop && !_actionTaken) {
          // El usuario salió sin tomar acción → reprogramar siguiente repetición
          NotificationService.scheduleNextRepeat(widget.task);
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(colors),
                const SizedBox(height: 32),
                _buildPulsingIcon(colors),
                const SizedBox(height: 28),
                _buildTaskCard(colors, task),
                const Spacer(),
                _buildActionButtons(colors),
                const SizedBox(height: 12),
                if (!_canExit) _buildLockHint(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    final total = StorageService.loadAlertDuration();
    final progress = total > 0 ? _secondsLeft / total : 0.0;
    final isUrgent = _secondsLeft <= 5 && !_canExit;

    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: _canExit ? 0 : progress.clamp(0.0, 1.0),
                strokeWidth: 4,
                backgroundColor: colors.outlineVariant,
                color: isUrgent ? colors.error : colors.primary,
              ),
              Text(
                _canExit ? '✓' : '$_secondsLeft',
                style: TextStyle(
                  fontSize: _canExit ? 20 : 15,
                  fontWeight: FontWeight.bold,
                  color: _canExit
                      ? colors.primary
                      : (isUrgent ? colors.error : colors.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _canExit ? '¡Tiempo cumplido!' : 'Recordatorio activo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _canExit ? colors.primary : colors.onSurface,
                ),
              ),
              Text(
                _canExit
                    ? 'Ya puedes salir o tomar acción'
                    : 'No puedes salir hasta que termine el contador',
                style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.55)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPulsingIcon(ColorScheme colors) {
    return Center(
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primaryContainer),
          child: Icon(Icons.notifications_active_rounded, size: 46, color: colors.primary),
        ),
      ),
    );
  }

  Widget _buildTaskCard(ColorScheme colors, Task task) {
    String timeLeftLabel() {
      final diff = task.dueDate.difference(DateTime.now());
      if (diff.isNegative) return 'Vencida';
      if (diff.inMinutes < 60) return 'Vence en ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Vence en ${diff.inHours} h';
      return 'Vence en ${diff.inDays} días';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.task_alt_rounded, color: colors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ]),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(task.description, style: TextStyle(fontSize: 14, color: colors.onSurface.withOpacity(0.7), height: 1.45)),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(children: [
            _metaChip(colors, icon: Icons.timer_outlined, label: timeLeftLabel(), color: colors.tertiary),
            const SizedBox(width: 10),
            _metaChip(colors, icon: Icons.repeat_rounded, label: _formatInterval(task.reminderInterval), color: colors.secondary),
          ]),
        ],
      ),
    );
  }

  Widget _metaChip(ColorScheme colors, {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildActionButtons(ColorScheme colors) {
    final enabled = _canExit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: enabled ? _onComplete : null,
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text('Completar tarea', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.primary.withOpacity(0.35),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: enabled ? _onDoingTask : null,
          icon: const Icon(Icons.play_circle_outline_rounded),
          label: const Text('Estoy realizando la tarea', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          style: FilledButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.secondary.withOpacity(0.35),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: enabled ? _onPostpone : null,
          icon: Icon(Icons.snooze_rounded, color: colors.onSurface.withOpacity(enabled ? 0.7 : 0.3)),
          label: Text('Posponer',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.onSurface.withOpacity(enabled ? 0.8 : 0.3))),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: BorderSide(color: colors.outline),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildLockHint(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_clock_outlined, size: 14, color: colors.onSurface.withOpacity(0.4)),
          const SizedBox(width: 5),
          Text('Salida disponible en $_secondsLeft s', style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.4))),
        ],
      ),
    );
  }

  String _formatInterval(Duration d) {
    if (d.inSeconds < 60) return 'Cada ${d.inSeconds}s';
    if (d.inMinutes < 60) return 'Cada ${d.inMinutes} min';
    return 'Cada ${d.inHours} h';
  }
}