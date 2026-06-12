import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:reminder_noescape/ui/widgets/app_row.dart';
import 'package:reminder_noescape/ui/widgets/section_card.dart';
import 'package:reminder_noescape/ui/widgets/section_title.dart';
import 'package:reminder_noescape/models/preferences_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<int, bool> _expandedHelp = {};

  static const _alertSounds = {
    'default': 'Sin sonido',
    'bell': 'Campana',
    'alarm': 'Alarma',
    'chime': 'Carillón',
    'buzzer': 'Zumbido',
    'custom': 'Personalizado',
    'silent': 'Silencio total',
  };

  static const _alertDurations = {
    3: '3 segundos',
    5: '5 segundos',
    10: '10 segundos',
    15: '15 segundos',
    20: '20 segundos',
  };

  static const _helpItems = [
    {
      'question': '¿Por qué no puedo detener la alerta permanentemente?',
      'answer': 'La única forma de detener los recordatorios es completando la tarea o esperando a que venza el tiempo límite. Esto es intencional para garantizar que no olvides tus tareas.',
    },
    {
      'question': '¿Qué significa el modo "Realizando tarea"?',
      'answer': 'Al presionar ese botón en la alerta, se activa una pausa temporal de 30 minutos para que los recordatorios no te interrumpan mientras trabajas en la tarea.',
    },
    {
      'question': '¿Cómo configuro el intervalo de repetición?',
      'answer': 'El intervalo se define al momento de crear cada recordatorio. Puedes elegir que la alerta se repita cada 30 segundos, 1 minuto, 5 minutos, entre otros.',
    },
    {
      'question': '¿Qué es el tiempo de anticipación?',
      'answer': 'Es el tiempo previo al límite de la tarea en el que la app comenzará a mostrarte recordatorios. Por ejemplo, si configuras 10 minutos de anticipación, las alertas empezarán 10 minutos antes del vencimiento.',
    },
  ];

  Widget _buildSelector<T>({
    required String label,
    required T current,
    required Map<T, String> options,
    required Future<void> Function(T) onSelected,
    required Color color,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () => _showOptions<T>(
              label: label,
              current: current,
              options: options,
              onSelected: onSelected,
            ),
            child: Row(
              children: [
                Text(
                  options[current] ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions<T>({
    required String label,
    required T current,
    required Map<T, String> options,
    required Future<void> Function(T) onSelected,
  }) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...options.entries.map((e) => ListTile(
                title: Text(e.value),
                trailing: e.key == current ? Icon(Icons.check, color: colors.primary) : null,
                onTap: () {
                  onSelected(e.key);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _pickCustomSound(PreferencesViewModel prefs) async {
    final path = await NotificationService.pickCustomSound();
    if (path != null) {
      await prefs.setCustomSoundPath(path);
    }
  }

  Future<void> _previewSound(PreferencesViewModel prefs) async {
    await NotificationService.previewSound(prefs.alertSound, prefs.customSoundPath);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final prefs = context.watch<PreferencesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            SectionTitle(color: colors.primary, label: 'Ajustes'),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                children: [
                  _buildSelector(
                    label: 'Tema',
                    icon: Icons.palette_outlined,
                    color: colors.primary,
                    current: prefs.theme,
                    options: const {'dark': 'Oscuro', 'light': 'Claro'},
                    onSelected: prefs.setTheme,
                  ),
                  Divider(height: 1, color: colors.outline),
                  _buildSelector(
                    label: 'Idioma',
                    icon: Icons.language_outlined,
                    color: colors.secondary,
                    current: prefs.language,
                    options: const {'es': 'Español', 'en': 'English'},
                    onSelected: prefs.setLanguage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: 'Sonido'),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                children: [
                  _buildSelector(
                    label: 'Sonido de alerta',
                    icon: Icons.volume_up_outlined,
                    color: colors.secondary,
                    current: prefs.alertSound,
                    options: _alertSounds,
                    onSelected: prefs.setAlertSound,
                  ),
                  if (prefs.alertSound == 'custom') ...[
                    Divider(height: 1, color: colors.outline),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.audio_file_outlined, color: colors.secondary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prefs.customSoundPath != null
                                  ? prefs.customSoundPath!.split('/').last
                                  : 'Ningún archivo seleccionado',
                              style: TextStyle(fontSize: 13, color: colors.onSurface.withOpacity(0.5)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _pickCustomSound(prefs),
                            child: Text('Elegir', style: TextStyle(color: colors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Divider(height: 1, color: colors.outline),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_outline, color: colors.primary, size: 22),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Vista previa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        TextButton(
                          onPressed: () => _previewSound(prefs),
                          child: Text('Reproducir', style: TextStyle(color: colors.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: 'Alerta'),
            const SizedBox(height: 12),
            SectionCard(
              child: _buildSelector(
                label: 'Duración de la alerta',
                icon: Icons.timer_outlined,
                color: colors.secondary,
                current: prefs.alertDuration,
                options: _alertDurations,
                onSelected: prefs.setAlertDuration,
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: 'Ayuda'),
            const SizedBox(height: 12),
            ...List.generate(_helpItems.length, (i) {
              final isExpanded = _expandedHelp[i] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _expandedHelp[i] = !isExpanded),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Icon(Icons.help_outline_rounded, size: 18, color: colors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _helpItems[i]['question']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: colors.onSurface.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 8),
                        Text(
                          _helpItems[i]['answer']!,
                          style: TextStyle(fontSize: 13, color: colors.onSurface.withOpacity(0.6), height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: 'Soporte'),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Icon(Icons.bug_report_outlined, color: colors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Reportar un problema', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: colors.onSurface.withOpacity(0.5)),
                  ]),
                ),
                Divider(height: 1, color: colors.outline),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/evaluation'),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(children: [
                      Icon(Icons.star_outline_rounded, color: colors.secondary, size: 22),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Calificar la app', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                      Icon(Icons.chevron_right, color: colors.onSurface.withOpacity(0.5)),
                    ]),
                  ),
                ),
                Divider(height: 1, color: colors.outline),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Icon(Icons.privacy_tip_outlined, color: colors.tertiary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Política de privacidad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    Icon(Icons.chevron_right, color: colors.onSurface.withOpacity(0.5)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}