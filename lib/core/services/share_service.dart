import 'package:share_plus/share_plus.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:intl/intl.dart';

class ShareService {
  static void sharePendingTasks(List<Task> tasks) {
  if (tasks.isEmpty) {
    Share.share('No tengo tareas pendientes actualmente.');
    return;
  }

  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  final buffer = StringBuffer();

  buffer.writeln('📋 Mis tareas pendientes:\n');

  for (int i = 0; i < tasks.length; i++) {
    final task = tasks[i];
    buffer.writeln('${i + 1}. ${task.title}');
    if (task.description.isNotEmpty) {
      buffer.writeln('   📝 ${task.description}');
    }
    buffer.writeln('   ⏰ Vence: ${formatter.format(task.dueDate)}');
    buffer.writeln();
  }

  buffer.writeln('Compartido desde Reminder NoEscape');

  Share.share(buffer.toString(), subject: 'Mis tareas pendientes');
}
}