class EvaluationQuestion 
{
  final String titulo;
  int valor;
  final String min;
  final String max;

  EvaluationQuestion
  ({
    required this.titulo,
    required this.valor,
    required this.min,
    required this.max,
  });

  factory EvaluationQuestion.fromJson(Map<String, dynamic> json) 
  {
    return EvaluationQuestion
    (
      titulo: json['titulo'],
      valor: json['valor'],
      min: json['min'],
      max: json['max'],
    );
  }
}

class EvaluationCategory 
{
  final String nombre;
  final List<EvaluationQuestion> preguntas;

  EvaluationCategory
  ({
    required this.nombre,
    required this.preguntas,
  });
}