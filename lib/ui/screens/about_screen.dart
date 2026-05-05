import 'package:flutter/material.dart';

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
            _SectionCard
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
            _SectionTitle(label: 'Cómo funciona', colors: colors),
            const SizedBox(height: 12),

            //alertas de pantalla
            _FeatureRow
            (
              icon: Icons.fullscreen_rounded,
              iconColor: colors.primary,
              title: 'Alertas en pantalla completa',
              subtitle: 'Cada recordatorio toma control total de la pantalla por el tiempo que definas.',
            ),

            //repeticion constante
            _FeatureRow(
              icon: Icons.repeat_rounded,
              iconColor: colors.primary,
              title: 'Repetición insistente',
              subtitle: 'Si cierras la alerta, vuelve según el intervalo que hayas configurado (30s, 1min, 5min…).',
            ),

            //modo pausa
            _FeatureRow(
              icon: Icons.pause_circle_rounded,
              iconColor: colors.secondary,
              title: 'Modo "Realizando tarea"',
              subtitle: 'Activa una pausa temporal para que no te interrumpa mientras trabajas en ello.',
            ),

            //validacion de tareas
            _FeatureRow
            (
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              title: 'Una sola salida',
              subtitle: 'Solo completando la tarea o al vencer el tiempo límite se detienen las alertas.',
            ),
            const SizedBox(height: 20),

            //anticipacion
            _SectionTitle(label: 'Anticipación', colors: colors),
            const SizedBox(height: 12),
            _SectionCard
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

//barra de encabezado
class _SectionTitle extends StatelessWidget 
{
  final String label;
  final ColorScheme colors;

  const _SectionTitle({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) 
  {
    return Align
    (
      alignment: Alignment.centerLeft,
      child: Row
      (
        children: 
        [
          Container
          (
            width: 4,
            height: 18,
            decoration: BoxDecoration
            (
              color: colors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(width: 8),
          Text
          (
            label,
            style: const TextStyle
            (
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//fondo para textos
class _SectionCard extends StatelessWidget 
{
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration
      (
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

//estructura de seccion
class _FeatureRow extends StatelessWidget 
{
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureRow
  ({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.only(bottom: 16),
      child: Row
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          Container
          (
            width: 42,
            height: 42,
            decoration: BoxDecoration
            (
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 14),
          Expanded
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                Text
                (
                  title,
                  style: const TextStyle
                  (
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),
                Text
                (
                  subtitle,
                  style: TextStyle
                  (
                    fontSize: 13,
                    color: const Color.fromARGB(255, 119, 119, 119),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}