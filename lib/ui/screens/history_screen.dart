import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/models/task_view_model.dart';
import 'package:reminder_noescape/ui/widgets/empty_state.dart';
import 'package:reminder_noescape/ui/widgets/task_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskViewModel>().history;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: tasks.isEmpty
          ? const EmptyState(
              imagePath: "assets/images/empty_history.png",
              title: "Sin historial aún",
              subtitle: "Las tareas completadas o vencidas aparecerán aquí",
            )
          : ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 90),
              itemBuilder: (context, index) => TaskCard(
                task: tasks[index],
                onTap: () => Navigator.pushNamed(context, '/taskDetail',
                    arguments: tasks[index]),
                showStatus: true,
              ),
            ),
    );
  }
}