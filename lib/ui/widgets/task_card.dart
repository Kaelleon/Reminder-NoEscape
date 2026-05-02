import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';

class TaskCard extends StatelessWidget
{
  final Task task;
  final VoidCallback onTap;
  final bool showStatus;
  
  const TaskCard
  ({
    super.key, 
    required this.task, 
    required this.onTap, 
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context)
  {
    final color = task.isCompleted ? Colors.green : Colors.red;
    final iconColor = showStatus ? color : Theme.of(context).colorScheme.primary;
    final iconData = showStatus ? (task.isCompleted ? Icons.check_circle : Icons.cancel) : Icons.notifications_active;
    final bgColor = showStatus ? color.withOpacity(0.1) : Theme.of(context).colorScheme.primary.withOpacity(0.1);
    
    return Card
    (
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile
      (
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar
        (
          backgroundColor: bgColor,
          child: Icon
          (
            iconData,
            color: iconColor,
          ),
        ),

        title: Text
        (
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        subtitle: Text
        (
          "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} • ${task.dueDate.hour.toString().padLeft(2,'0')}:${task.dueDate.minute.toString().padLeft(2,'0')}",
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: showStatus
          ? Chip
          (
            label: Text
            (
              task.isCompleted ? "Cumplida" : "No cumplida",
              style: TextStyle(color: color, fontSize: 12),
            ),
            backgroundColor: color.withOpacity(0.1),
          )
          : const Icon(Icons.chevron_right),
      ),
    );
  }
}