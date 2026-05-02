import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget 
{
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  String _formatDateTime(DateTime dt)
  {
    return "${dt.day}/${dt.month}/${dt.year} "
      "${dt.hour.toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')}";
  }

  String _formatInterval(Duration d) 
  {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);

    final parts = <String>[];
    if (h > 0) parts.add("${h}h");
    if (m > 0) parts.add("${m}m");
    if (s > 0) parts.add("${s}s");

    return parts.isEmpty ? "0s" : parts.join(" ");
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text("Detalle del recordatorio"),
      ),

      body: Padding
      (
        padding: const EdgeInsets.all(24),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            Center
            (
              child: CircleAvatar
              (
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon
                (
                  Icons.notifications_active,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            _DetailItem
            (
              icon: Icons.title,
              label: "Título",
              value: task.title,
            ),

            const Divider(),

            if (task.description.isNotEmpty) ...
            [
              _DetailItem
              (
                icon: Icons.notes,
                label: "Descripción",
                value: task.description,
              ),
              const Divider(),
            ],

            _DetailItem
            (
              icon: Icons.calendar_today,
              label: "Fecha límite",
              value: _formatDateTime(task.dueDate),
            ),
            const Divider(),

            _DetailItem
            (
              icon: Icons.alarm,
              label: "Inicio de recordatorio",
              value: _formatDateTime(task.anticipationTime),
            ),
            const Divider(),

            _DetailItem
            (
              icon: Icons.repeat, 
              label: "Intervalo", 
              value: "Cada ${_formatInterval(task.reminderInterval)}",
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget 
{
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem
  ({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row
      (
        children: 
        [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Text
              (
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              Text
              (
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}