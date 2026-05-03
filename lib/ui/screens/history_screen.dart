import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/widgets/empty_state.dart';
import 'package:reminder_noescape/ui/widgets/task_card.dart';

class HistoryScreen extends StatelessWidget
{
  const HistoryScreen({super.key});

   static final List<Task> _mockTasks =
  [
    Task
    (
      title: "Entregar informe",
      description: "Informe mensual de ventas",
      dueDate: DateTime(2025, 5, 1, 9, 0),
      anticipationTime: DateTime(2025, 4, 30, 9, 0),
      reminderInterval: const Duration(hours: 1),
      isCompleted: true,
    ),

    Task
    (
      title: "Llamar al cliente",
      description: "Seguimiento del proyecto",
      dueDate: DateTime(2025, 5, 2, 11, 0),
      anticipationTime: DateTime(2025, 5, 2, 10, 0),
      reminderInterval: const Duration(minutes: 30),
      isCompleted: false,
    ),

    Task
    (
      title: "Pagar factura",
      description: "",
      dueDate: DateTime(2025, 5, 3, 18, 0),
      anticipationTime: DateTime(2025, 5, 3, 16, 0),
      reminderInterval: const Duration(minutes: 15),
      isCompleted: true,
    ),

    Task
    (
      title: "Reunión de equipo",
      description: "Revisión del sprint",
      dueDate: DateTime(2025, 5, 4, 14, 0),
      anticipationTime: DateTime(2025, 5, 4, 13, 0),
      reminderInterval: const Duration(hours: 2),
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Colors.transparent,
      body: _mockTasks.isEmpty ? const EmptyState
      (
        imagePath: "assets/images/empty_history.png",
        title: "Sin historial aún",
        subtitle: "Las tareas completadas o vencidas aparecerán aquí",
      )

      :ListView.builder
      (
        itemCount: _mockTasks.length,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 90),
        itemBuilder: (context, index) => TaskCard
        (
          task: _mockTasks[index], 
          onTap: () => Navigator.pushNamed(context, '/taskDetail', arguments: _mockTasks[index],),
          showStatus: true,
        ),
      ),
    );
  }
}