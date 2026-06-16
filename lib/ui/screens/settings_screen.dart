import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:reminder_noescape/l10n/app_localizations.dart';
import 'package:reminder_noescape/ui/widgets/section_card.dart';
import 'package:reminder_noescape/ui/widgets/section_title.dart';
import 'package:reminder_noescape/models/preferences_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<int, bool> _expandedHelp = {};

  Map<String, String> get _alertSounds {
    final l10n = AppLocalizations.of(context)!;
    return {
      'default': l10n.sinSonido,
      'bell': l10n.locale.languageCode == 'en' ? 'Bell' : 'Campana',
      'alarm': l10n.locale.languageCode == 'en' ? 'Alarm' : 'Alarma',
      'chime': l10n.locale.languageCode == 'en' ? 'Chime' : 'Carillón',
      'buzzer': l10n.locale.languageCode == 'en' ? 'Buzzer' : 'Zumbido',
    };
  }

  Map<int, String> get _alertDurations {
    final seg = AppLocalizations.of(context)!.segundos;
    return {
      3: '3 $seg',
      5: '5 $seg',
      10: '10 $seg',
      15: '15 $seg',
      20: '20 $seg',
    };
  }

  List<Map<String, String>> get _helpItems {
    final l10n = AppLocalizations.of(context)!;
    final isEn = l10n.locale.languageCode == 'en';
    return [
      {
        'question': isEn ? "Why can't I permanently stop the alert?" : '¿Por qué no puedo detener la alerta permanentemente?',
        'answer': isEn ? "The only way to stop reminders is by completing the task or waiting until the time limit expires. This is intentional to ensure you don't forget your tasks." : 'La única forma de detener los recordatorios es completando la tarea o esperando a que venza el tiempo límite. Esto es intencional para garantizar que no olvides tus tareas.',
      },
      {
        'question': isEn ? 'What does "Doing task" mode mean?' : '¿Qué significa el modo "Realizando tarea"?',
        'answer': isEn ? "Pressing that button on the alert activates a 30-minute pause so reminders don't interrupt you while you work on the task." : 'Al presionar ese botón en la alerta, se activa una pausa temporal de 30 minutos para que los recordatorios no te interrumpan mientras trabajas en la tarea.',
      },
      {
        'question': isEn ? 'How do I configure the repeat interval?' : '¿Cómo configuro el intervalo de repetición?',
        'answer': isEn ? 'The interval is set when creating each reminder. You can choose alerts to repeat every 30 seconds, 1 minute, 5 minutes, among others.' : 'El intervalo se define al momento de crear cada recordatorio. Puedes elegir que la alerta se repita cada 30 segundos, 1 minuto, 5 minutos, entre otros.',
      },
      {
        'question': isEn ? 'What is anticipation time?' : '¿Qué es el tiempo de anticipación?',
        'answer': isEn ? "It's the time before the task deadline when the app will start showing reminders. For example, if you set 10 minutes anticipation, alerts will start 10 minutes before the deadline." : 'Es el tiempo previo al límite de la tarea en el que la app comenzará a mostrarte recordatorios. Por ejemplo, si configuras 10 minutos de anticipación, las alertas empezarán 10 minutos antes del vencimiento.',
      },
    ];
  }

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

  Future<void> _reportProblem() async {
    final subject = Uri.encodeComponent('Reporte de problema - Reminder: No Escape');
    final body = Uri.encodeComponent('Describe el problema que encontraste:\n\n');
    final uri = Uri.parse('mailto:capi.bara.mp.2026@gmail.com?subject=$subject&body=$body');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró una app de correo instalada')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final prefs = context.watch<PreferencesViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.configuracion, style: const TextStyle(fontWeight: FontWeight.bold)),
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

            SectionTitle(color: colors.primary, label: l10n.locale.languageCode == 'en' ? 'Settings' : 'Ajustes'),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                children: [
                  _buildSelector(
                    label: l10n.tema,
                    icon: Icons.palette_outlined,
                    color: colors.primary,
                    current: prefs.theme,
                    options: {'dark': l10n.oscuro, 'light': l10n.claro},
                    onSelected: prefs.setTheme,
                  ),
                  Divider(height: 1, color: colors.outline),
                  _buildSelector(
                    label: l10n.idioma,
                    icon: Icons.language_outlined,
                    color: colors.secondary,
                    current: prefs.language,
                    options: {'es': l10n.espanol, 'en': l10n.ingles},
                    onSelected: prefs.setLanguage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: l10n.sonido),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                children: [
                  _buildSelector(
                    label: l10n.sonidoAlerta,
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
                                  : l10n.ningunArchivo,
                              style: TextStyle(fontSize: 13, color: colors.onSurface.withOpacity(0.5)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _pickCustomSound(prefs),
                            child: Text(l10n.elegir, style: TextStyle(color: colors.primary)),
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
                        Expanded(
                          child: Text(l10n.vistaPrevia, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        TextButton(
                          onPressed: () => _previewSound(prefs),
                          child: Text(l10n.reproducir, style: TextStyle(color: colors.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: l10n.alerta),
            const SizedBox(height: 12),
            SectionCard(
              child: _buildSelector(
                label: l10n.duracionAlerta,
                icon: Icons.timer_outlined,
                color: colors.secondary,
                current: prefs.alertDuration,
                options: _alertDurations,
                onSelected: prefs.setAlertDuration,
              ),
            ),
            const SizedBox(height: 20),

            SectionTitle(color: colors.primary, label: l10n.ayuda),
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

            SectionTitle(color: colors.primary, label: l10n.soporte),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(children: [
                GestureDetector(
                  onTap: () => _reportProblem(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(children: [
                      Icon(Icons.bug_report_outlined, color: colors.primary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l10n.reportar, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                      Icon(Icons.chevron_right, color: colors.onSurface.withOpacity(0.5)),
                    ]),
                  ),
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
                      Expanded(child: Text(l10n.calificar, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                      Icon(Icons.chevron_right, color: colors.onSurface.withOpacity(0.5)),
                    ]),
                  ),
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