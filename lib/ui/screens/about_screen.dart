import 'package:flutter/material.dart';
import 'package:reminder_noescape/ui/widgets/app_row.dart';
import 'package:reminder_noescape/ui/widgets/section_title.dart';
import 'package:reminder_noescape/ui/widgets/section_card.dart';

class AboutScreen extends StatelessWidget 
{
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;

    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text
        (
          'Acerca de',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView
      (
        padding: const EdgeInsets.all(24),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: 
          [
            const SizedBox(height: 16),

            //logo de la aplicacion
            ClipRRect
            (
              borderRadius: BorderRadius.circular(24),
              child: Image.asset
              (
                'assets/icons/reminder_no_escape.png', 
                width: 96, 
                height: 96, 
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            //nombre de la app
            const Text
            (
              'Reminder: No Escape',
              style: TextStyle
              (
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            //version de la aplicacion
            Text
            (
              'Versión 1.0.0',
              style: TextStyle
              (
                fontSize: 13,
                color: const Color.fromARGB(255, 119, 119, 119),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),

            //descripcion
            SectionCard
            (
              child: const Text
              (
                'Reminder: No Escape es un recordatorio que no acepta ser ignorado. '
                'Las alertas aparecen en pantalla completa de forma insistente hasta '
                'que completes la tarea o se agote el tiempo límite.',
                style: TextStyle(fontSize: 15, height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            //funcionamiento
            SectionTitle(label: 'Cómo funciona', color: colors.primary),
            const SizedBox(height: 12),

            //alertas de pantalla
            AppRow
            (
              icon: Icons.fullscreen_rounded,
              iconColor: colors.primary,
              iconContainer: true,
              label: 'Alertas en pantalla completa',
              subtitle: 'Cada recordatorio toma control total de la pantalla por el tiempo que definas.',
            ),

            //repeticion constante
            AppRow
            (
              icon: Icons.repeat_rounded,
              iconColor: colors.primary,
              iconContainer: true,
              label: 'Repetición insistente',
              subtitle: 'Si cierras la alerta, vuelve según el intervalo que hayas configurado (30s, 1min, 5min…).',
            ),

            //modo pausa
            AppRow
            (
              icon: Icons.pause_circle_rounded,
              iconColor: colors.secondary,
              iconContainer: true,
              label: 'Modo "Realizando tarea"',
              subtitle: 'Activa una pausa temporal para que no te interrumpa mientras trabajas en ello.',
            ),

            //validacion de tareas
            AppRow
            (
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              iconContainer: true,
              label: 'Una sola salida',
              subtitle: 'Solo completando la tarea o al vencer el tiempo límite se detienen las alertas.',
            ),
            const SizedBox(height: 20),

            //anticipacion
            SectionTitle(label: 'Anticipación', color: colors.primary),
            const SizedBox(height: 12),
            SectionCard
            (
              child: Row
              (
                children: 
                [
                  Icon(Icons.access_time_rounded, color: colors.primary, size: 28),
                  const SizedBox(width: 14),
                  const Expanded
                  (
                    child: Text
                    (
                      'Configura con cuánta anticipación quieres que empiecen '
                      'los recordatorios antes del tiempo límite de cada tarea.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text
            (
              '© 2026 Reminder No Escape',
              style: TextStyle
              (
                fontSize: 12,
                color: const Color.fromARGB(255, 119, 119, 119),
              ),
            ),
            const SizedBox(height: 8),
            
            Text
            (
              'Hecho con ♥ para que no olvides nada',
              style: TextStyle
              (
                fontSize: 12,
                color: const Color.fromARGB(255, 119, 119, 119),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}