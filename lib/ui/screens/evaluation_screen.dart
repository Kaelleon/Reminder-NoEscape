import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reminder_noescape/models/question_model.dart';
import 'package:reminder_noescape/models/evaluation_view_model.dart';
import 'package:reminder_noescape/ui/widgets/section_card.dart';
import 'package:reminder_noescape/ui/widgets/section_title.dart';

class EvaluationScreen extends StatefulWidget 
{
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> 
{
  @override
  void initState() 
  {
    super.initState();
    context.read<EvaluationViewModel>().loadQuestions();
  }

  Future<void> _sendEmail(EvaluationViewModel vm) async 
  {
    final subject = Uri.encodeComponent('Evaluación Reminder: No Escape');
    final body = Uri.encodeComponent(vm.buildEmailBody());

    final uri = Uri.parse('mailto:capi.bara.mp.2026@gmail.com?subject=$subject&body=$body');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) 
    {
      if (mounted) 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          const SnackBar
          (
            content: Text('No se encontró una app de correo instalada'),
          ),
        );
      }
    }
  }

  Widget _buildStarRating
  ({
    required EvaluationCategory category,
    required EvaluationQuestion question,
    required EvaluationViewModel vm,
    required Color activeColor,
  }) 

  {
    return Row
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) 
      {
        final starValue = i + 1;
        return GestureDetector
        (
          onTap: () => vm.setAnswer(category, question, starValue),
          child: Padding
          (
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon
            (
              question.valor >= starValue ? Icons.star_rounded : Icons.star_outline_rounded,
              color: question.valor >= starValue ? activeColor : activeColor.withOpacity(0.3),
              size: 36,
            ),
          ),
        );
      }),
    );
  }

  //nombre para cada categoria
  String _categoryLabel(String key) 
  {
    const labels = 
    {
      'usabilidad': 'Usabilidad',
      'contenido': 'Contenido',
      'compartir': 'Compartir',
    };
    return labels[key] ?? key;
  }

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<EvaluationViewModel>();

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Evaluación', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      body: vm.isLoading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView
        (
          padding: const EdgeInsets.all(24),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              const SizedBox(height: 8),

              //introduccion
              SectionCard
              (
                child: Row
                (
                  children: 
                  [
                    Icon(Icons.info_outline, color: colors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded
                    (
                      child: Text
                      (
                        'Responde todas las preguntas con estrellas y luego presiona Enviar para compartir tu evaluación.',
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              //categorias y preguntas
              ...vm.categories.map((cat) 
              {
                // olor por categoría
                final catColor = switch (cat.nombre) 
                {
                  'usabilidad' => colors.secondary,
                  'contenido'  => colors.secondary,
                  'compartir'  => colors.secondary,
                  _ => colors.primary,
                };

                return Column
                (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                  [
                    SectionTitle(label: _categoryLabel(cat.nombre), color: catColor),
                    const SizedBox(height: 12),

                    ...cat.preguntas.map((q) => Padding
                    (
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SectionCard
                      (
                        child: Column
                        (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: 
                          [
                            Text
                            (
                              q.titulo,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),

                            _buildStarRating
                            (
                              category: cat,
                              question: q,
                              vm: vm,
                              activeColor: catColor,
                            ),
                            const SizedBox(height: 12),

                            //min y max
                            Row
                            (
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: 
                              [
                                Text
                                (
                                  q.min,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                
                                Text
                                (
                                  q.max,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(height: 12),
                  ],
                );
              }),

              //boton enviar
              SizedBox
              (
                width: double.infinity,
                child: ElevatedButton.icon
                (
                  onPressed: vm.allAnswered ? () => _sendEmail(vm) : null,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Enviar evaluación'),
                  style: ElevatedButton.styleFrom
                  (
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: colors.outline,
                    disabledForegroundColor: colors.onSurface.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              //aviso si faltan preguntas por responder
              if (!vm.allAnswered) ...[
                const SizedBox(height: 8),
                Center
                (
                  child: Text
                  (
                    'Responde todas las preguntas para poder enviar',
                    style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.5)),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
    );
  }
}