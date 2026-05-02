
class Task
{
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime anticipationTime;
  final Duration reminderInterval;
  bool isCompleted;

  Task
  ({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.anticipationTime,
    required this.reminderInterval,
    this.isCompleted = false,
  });
}