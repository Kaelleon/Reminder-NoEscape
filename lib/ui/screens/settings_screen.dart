import 'package:flutter/material.dart';
import 'package:reminder_noescape/ui/widgets/section_title.dart';
import 'package:reminder_noescape/ui/widgets/section_card.dart';

class SettingsScreen extends StatelessWidget
{
  const SettingsScreen({super.key});

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
          'Configuración',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            const SizedBox(height: 8),

            //ajustes
            SectionTitle(color: colors.primary, label: 'Ajustes'),
            const SizedBox(height: 12),

            SectionCard
            (
              child: Column
              (
                children:
                [
                  _SettingsRow
                  (
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF5C6BC0),
                    label: 'Tema',
                    trailing: Text
                    (
                      'Claro',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _SettingsRow
                  (
                    icon: Icons.language_outlined,
                    iconColor: const Color(0xFF26A69A),
                    label: 'Idioma',
                    trailing: Text
                    (
                      'Español',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //sonido y notificaciones
            SectionTitle(color: colors.primary, label: 'Sonido y notificaciones'),
            const SizedBox(height: 12),

            SectionCard
            (
              child: Column
              (
                children:
                [
                  _SettingsRow
                  (
                    icon: Icons.volume_up_outlined,
                    iconColor: const Color(0xFFFFA726),
                    label: 'Sonido de alerta',
                    trailing: Text
                    (
                      'Predeterminado',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _SettingsRow
                  (
                    icon: Icons.vibration_rounded,
                    iconColor: const Color(0xFF546E7A),
                    label: 'Vibración',
                    trailing: Switch
                    (
                      value: true,
                      onChanged: null,
                      activeColor: colors.primary,
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _SettingsRow
                  (
                    icon: Icons.flashlight_on_outlined,
                    iconColor: const Color(0xFF26A69A),
                    label: 'Flash de alerta',
                    trailing: Switch
                    (
                      value: false,
                      onChanged: null,
                      activeColor: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            //ayuda
            SectionTitle(color: colors.primary, label: 'Ayuda'),
            const SizedBox(height: 12),

            SectionCard
            (
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Icon(Icons.help_outline_rounded, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      const Expanded
                      (
                        child: Text
                        (
                          '¿Por qué no puedo detener la alerta permanentemente?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text
                  (
                    'La única forma de detener los recordatorios es completando la tarea o esperando a que venza el tiempo límite. Esto es intencional para garantizar que no olvides tus tareas.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            SectionCard
            (
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Icon(Icons.help_outline_rounded, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      const Expanded
                      (
                        child: Text
                        (
                          '¿Qué significa el modo "Realizando tarea"?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text
                  (
                    'Al presionar ese botón en la alerta, se activa una pausa temporal de 30 minutos para que los recordatorios no te interrumpan mientras trabajas en la tarea.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            SectionCard
            (
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Icon(Icons.help_outline_rounded, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      const Expanded
                      (
                        child: Text
                        (
                          '¿Cómo configuro el intervalo de repetición?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text
                  (
                    'El intervalo se define al momento de crear cada recordatorio. Puedes elegir que la alerta se repita cada 30 segundos, 1 minuto, 5 minutos, entre otros.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            SectionCard
            (
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Icon(Icons.help_outline_rounded, size: 18, color: colors.primary),
                      const SizedBox(width: 8),
                      const Expanded
                      (
                        child: Text
                        (
                          '¿Qué es el tiempo de anticipación?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text
                  (
                    'Es el tiempo previo al límite de la tarea en el que la app comenzará a mostrarte recordatorios. Por ejemplo, si configuras 10 minutos de anticipación, las alertas empezarán 10 minutos antes del vencimiento.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),


            //soporte
            SectionTitle(color: colors.primary, label: 'Soporte'),
            const SizedBox(height: 12),

            SectionCard
            (
              child: Column
              (
                children:
                [
                  _SettingsRow
                  (
                    icon: Icons.bug_report_outlined,
                    iconColor: colors.primary,
                    label: 'Reportar un problema',
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _SettingsRow
                  (
                    icon: Icons.star_outline_rounded,
                    iconColor: const Color(0xFFFFA726),
                    label: 'Calificar la app',
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),

                  _SettingsRow
                  (
                    icon: Icons.privacy_tip_outlined,
                    iconColor: const Color(0xFF546E7A),
                    label: 'Política de privacidad',
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

//estructura fila de ajustes
class _SettingsRow extends StatelessWidget
{
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;

  const _SettingsRow
  ({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context)
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row
      (
        children:
        [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded
          (
            child: Text
            (
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}