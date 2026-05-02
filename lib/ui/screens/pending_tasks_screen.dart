import 'package:flutter/material.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/widgets/add_task_sheet.dart';
import 'package:reminder_noescape/ui/widgets/task_card.dart';

class PendingTasksScreen extends StatefulWidget
{
  const PendingTasksScreen({super.key});

  @override
  State<PendingTasksScreen> createState() => _PendingTaskScreenState();
}

class _PendingTaskScreenState extends State<PendingTasksScreen> 
  with AutomaticKeepAliveClientMixin //para mantener vivos los widget
{
  final List<Task> _tasks = [];

  @override
  bool get wantKeepAlive => _tasks.isNotEmpty;

  void _openAddTaskSheet()
  {
    showModalBottomSheet
    (
      context: context, 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder
      (
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      
      builder: (_) => DraggableScrollableSheet
      (
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView
        (
          controller: scrollController,
          child: AddTaskSheet
          (
            onTaskAdded: (task) => setState(() => _tasks.add(task)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    super.build(context);
    return Scaffold
    (
      backgroundColor: Colors.transparent,
      body: _tasks.isEmpty ? _buildEmptyState() : ListView.builder
      (
        padding: const EdgeInsets.only
        (
          top: 16,
          left: 16,
          right: 16,
          bottom: 90,
        ),

        itemCount: _tasks.length,
        itemBuilder: (context, index) => TaskCard
        (
          task: _tasks[index],
          onTap: () => Navigator.pushNamed(context, '/taskDetail', arguments: _tasks[index],),
        ),
      ),

      floatingActionButton: FloatingActionButton
      (
        onPressed: _openAddTaskSheet,
        tooltip: "Agregar recordatorio",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState()
  {
    return Center
    (
      child: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            //imagen central
            Image.asset("assets/images/empty.png", height: 150),
            const SizedBox(height: 30),
            //texto principal
            const Text
            (
              "Organiza ahora, cumple a tiempo",
              textAlign: TextAlign.center,
              style: TextStyle
              (
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 15),

            //texto secundario
            const Text
            (
              "Añade tus tareas y recibe recordatorios constantes para asegurarte de completarlas antes del límite.",
              textAlign: TextAlign.center,
              style: TextStyle
              (
                fontSize: 16,
                color: Color.fromARGB(179, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}