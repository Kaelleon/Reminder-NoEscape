import 'package:flutter/material.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _pending = [];
  final List<Task> _history = [];

  List<Task> get pending => List.unmodifiable(_pending);
  List<Task> get history => List.unmodifiable(_history);

  TaskViewModel() {
    _loadFromStorage();
  }

  // ── Carga inicial desde almacenamiento ────────────────────────────────────
  void _loadFromStorage() {
    final pendingData = StorageService.loadPendingTasks();
    final historyData = StorageService.loadHistoryTasks();

    _pending.clear();
    _pending.addAll(pendingData.map((j) => Task.fromJson(j)));

    _history.clear();
    _history.addAll(historyData.map((j) => Task.fromJson(j)));

    // Al cargar, revisa si alguna pendiente ya venció mientras la app estaba cerrada
    _checkOverdueTasks(persist: false);

    _persist();
    notifyListeners();
  }

  // ── Persistencia ─────────────────────────────────────────────────────────
  Future<void> _persist() async {
    await StorageService.savePendingTasks(_pending.map((t) => t.toJson()).toList());
    await StorageService.saveHistoryTasks(_history.map((t) => t.toJson()).toList());
  }

  // ── Agregar tarea pendiente ───────────────────────────────────────────────
  void addTask(Task task) {
    _pending.add(task);
    _persist();
    notifyListeners();
  }

  // ── Completar tarea (manual, por id) ────────────────────────────────────
  void completeTask(Task task) {
    completeTaskById(task.id);
  }

  void completeTaskById(String id) {
    final index = _pending.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _pending.removeAt(index);
    final completed = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      anticipationTime: task.anticipationTime,
      reminderInterval: task.reminderInterval,
      isCompleted: true,
    );
    _history.add(completed);
    _persist();
    notifyListeners();
  }

  // ── Marcar como no cumplida (vencida) ────────────────────────────────────
  void markAsIncompleteById(String id) {
    final index = _pending.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _pending.removeAt(index);
    final incomplete = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      anticipationTime: task.anticipationTime,
      reminderInterval: task.reminderInterval,
      isCompleted: false,
    );
    _history.add(incomplete);
    _persist();
    notifyListeners();
  }

  // ── Reemplazar/actualizar una tarea pendiente (reprogramación) ────────────
  void updateTask(Task updated) {
    final index = _pending.indexWhere((t) => t.id == updated.id);
    if (index == -1) {
      _pending.add(updated);
    } else {
      _pending[index] = updated;
    }
    _persist();
    notifyListeners();
  }

  // ── Revisa pendientes vencidas y las mueve a historial como no cumplidas ──
  void _checkOverdueTasks({bool persist = true}) {
    final now = DateTime.now();
    final overdue = _pending.where((t) => t.dueDate.isBefore(now)).toList();

    for (final task in overdue) {
      _pending.remove(task);
      _history.add(Task(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        anticipationTime: task.anticipationTime,
        reminderInterval: task.reminderInterval,
        isCompleted: false,
      ));
    }

    if (overdue.isNotEmpty && persist) {
      _persist();
    }
  }

  /// Llamar al reanudar la app (ej. desde main.dart con WidgetsBindingObserver)
  void checkOverdueTasks() {
    _checkOverdueTasks();
    if (_pending.any((t) => t.dueDate.isBefore(DateTime.now()))) {
      notifyListeners();
    } else {
      notifyListeners(); // por si cambió el historial
    }
  }

  // ── Buscar tarea por título (compatibilidad con NotificationService) ─────
  Task? findByTitle(String title) {
    try {
      return _pending.firstWhere((t) => t.title == title);
    } catch (_) {
      return null;
    }
  }

  Task? findById(String id) {
    try {
      return _pending.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}