import 'package:flutter/material.dart';
import 'package:reminder_noescape/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold
    (
      appBar: AppBar
      (
        title: Text
        (
          l10n.acercaDe,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              '${l10n.version} 1.0.0',
              style: TextStyle
              (
                fontSize: 13,
                color: colors.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),

            //descripcion
            SectionCard
            (
              child: Text
              (
                l10n.descripcionApp,
                style: const TextStyle(fontSize: 15, height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            //funcionamiento
            SectionTitle(label: l10n.comoFunciona, color: colors.primary),
            const SizedBox(height: 12),

            //alertas de pantalla
            AppRow
            (
              icon: Icons.fullscreen_rounded,
              iconColor: colors.primary,
              iconContainer: true,
              label: l10n.alertasPantalla,
              subtitle: l10n.alertasPantallaDesc,
            ),

            //repeticion constante
            AppRow
            (
              icon: Icons.repeat_rounded,
              iconColor: colors.primary,
              iconContainer: true,
              label: l10n.repeticion,
              subtitle: l10n.repeticionDesc,
            ),

            //modo pausa
            AppRow
            (
              icon: Icons.pause_circle_rounded,
              iconColor: colors.secondary,
              iconContainer: true,
              label: l10n.modoPausa,
              subtitle: l10n.modoPausaDesc,
            ),

            //validacion de tareas
            AppRow
            (
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              iconContainer: true,
              label: l10n.unaSalida,
              subtitle: l10n.unaSalidaDesc,
            ),
            const SizedBox(height: 20),

            //anticipacion
            SectionTitle(label: l10n.anticipacion, color: colors.primary),
            const SizedBox(height: 12),
            SectionCard
            (
              child: Row
              (
                children: 
                [
                  Icon(Icons.access_time_rounded, color: colors.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded
                  (
                    child: Text
                    (
                      l10n.anticipacionDesc,
                      style: const TextStyle(fontSize: 14, height: 1.5),
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
                color: colors.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            
            Text
            (
              l10n.hechoCon,
              style: TextStyle
              (
                fontSize: 12,
                color: colors.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}