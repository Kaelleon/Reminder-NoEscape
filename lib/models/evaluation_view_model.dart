import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reminder_noescape/models/question_model.dart';

class EvaluationViewModel extends ChangeNotifier
{
  List<EvaluationCategory> _categories = [];
  bool _isLoading = true;

  List<EvaluationCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  //verifica si estan todas las respuestas de cada pregunta
  bool get allAnswered => _categories
    .every((cat) => cat.preguntas.every((q) => q.valor > 0));

  Future<void> loadQuestions() async 
  {
    final jsonString = await rootBundle.loadString('assets/data/questions.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    _categories = jsonData.entries.map((entry) 
    {
      return EvaluationCategory
      (
        nombre: entry.key,
        preguntas: (entry.value as List)
          .map((q) => EvaluationQuestion.fromJson(q))
          .toList(),
      );
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  void setAnswer(EvaluationCategory category, EvaluationQuestion question, int value) 
  {
    question.valor = value;
    notifyListeners();
  }

  //construye el correo con los resultados de las preguntas
  String buildEmailBody() 
  {
    final buffer = StringBuffer();
    buffer.writeln('Resultados de evaluación — Reminder: No Escape\n');

    for (final cat in _categories) 
    {
      buffer.writeln('── ${cat.nombre.toUpperCase()} ──');
      for (final q in cat.preguntas) 
      {
        buffer.writeln('${q.titulo}');
        buffer.writeln('Respuesta: ${'★' * q.valor}${'☆' * (5 - q.valor)} (${q.valor}/5)\n');
      }
    }
    return buffer.toString();
  }
}