import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final bool showStatus;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.showStatus = false,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final color = task.isCompleted ? Colors.green : Colors.red;
    final iconColor = showStatus ? color : Theme.of(context).colorScheme.primary;
    final iconData = showStatus
        ? (task.isCompleted ? Icons.check_circle : Icons.cancel)
        : Icons.notifications_active;
    final bgColor = showStatus
        ? color.withOpacity(0.1)
        : Theme.of(context).colorScheme.primary.withOpacity(0.1);

    final card = Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} • "
          "${task.dueDate.hour.toString().padLeft(2, '0')}:${task.dueDate.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: showStatus
            ? Chip(
                label: Text(
                  task.isCompleted ? "Cumplida" : "No cumplida",
                  style: TextStyle(color: color, fontSize: 12),
                ),
                backgroundColor: color.withOpacity(0.1),
              )
            : const Icon(Icons.chevron_right),
      ),
    );

    // Solo permitir swipe-to-complete en tareas pendientes (no en historial)
    if (showStatus || onComplete == null) {
      return card;
    }

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onComplete?.call();
        return false; // no remover de la lista aquí; el ViewModel lo hará y rebuild llegará por notifyListeners
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.check_circle, color: Colors.white, size: 28),
      ),
      child: card,
    );
  }
}