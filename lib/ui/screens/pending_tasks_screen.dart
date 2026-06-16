import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:reminder_noescape/l10n/app_localizations.dart';
import 'package:reminder_noescape/models/task_view_model.dart';
import 'package:reminder_noescape/ui/widgets/add_task_sheet.dart';
import 'package:reminder_noescape/ui/widgets/empty_state.dart';
import 'package:reminder_noescape/ui/widgets/task_card.dart';

class PendingTasksScreen extends StatelessWidget {
  const PendingTasksScreen({super.key});

  void _openAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: AddTaskSheet(
            onTaskAdded: (task) async {
              context.read<TaskViewModel>().addTask(task);
              await NotificationService.scheduleTaskNotification(task);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tasks = context.watch<TaskViewModel>().pending;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: tasks.isEmpty
          ? EmptyState(
              imagePath: "assets/images/empty.png",
              title: l10n.organizaAhora,
              subtitle: l10n.organizaAhoraDesc,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 90),
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskCard(
                task: tasks[index],
                onTap: () => Navigator.pushNamed(context, '/taskDetail',
                    arguments: tasks[index]),
                onComplete: () async {
                  final task = tasks[index];
                  await NotificationService.cancelTaskNotification(task);
                  context.read<TaskViewModel>().completeTask(task);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTaskSheet(context),
        tooltip: l10n.locale.languageCode == 'en' ? 'Add reminder' : "Agregar recordatorio",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}