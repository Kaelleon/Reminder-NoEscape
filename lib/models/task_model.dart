class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime anticipationTime;
  final Duration reminderInterval;
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.anticipationTime,
    required this.reminderInterval,
    this.isCompleted = false,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  // ── Serialización para persistencia ───────────────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'anticipationTime': anticipationTime.toIso8601String(),
        'reminderIntervalSeconds': reminderInterval.inSeconds,
        'isCompleted': isCompleted,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        anticipationTime: DateTime.parse(json['anticipationTime'] as String),
        reminderInterval:
            Duration(seconds: json['reminderIntervalSeconds'] as int),
        isCompleted: json['isCompleted'] as bool,
      );
}