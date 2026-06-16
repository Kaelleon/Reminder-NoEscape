import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/models/task_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  String _userName = '';
  String _imagePath = '';
  String _memberSince = '';
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _userName = StorageService.loadProfileName();
    _imagePath = StorageService.loadProfileImagePath();
    _memberSince = StorageService.loadMemberSince();

    // Si no hay fecha de registro, guardar la actual
    if (_memberSince.isEmpty) {
      final now = DateTime.now();
      final months = [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      _memberSince = '${months[now.month - 1]} ${now.year}';
      StorageService.saveMemberSince(_memberSince);
    }

    _nameController = TextEditingController(text: _userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccionar imagen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Galería'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Cámara'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        await StorageService.saveProfileImagePath(_imagePath);
      }
    }
  }

  void _editName() {
    _nameController.text = _userName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Editar nombre'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: 'Escribe tu nombre',
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final newName = _nameController.text.trim();
              if (newName.isNotEmpty) {
                setState(() {
                  _userName = newName;
                });
                await StorageService.saveProfileName(newName);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskVM = context.watch<TaskViewModel>();

    // Estadísticas reales
    final completedCount = taskVM.history.where((t) => t.isCompleted).length;
    final pendingCount = taskVM.pending.length;
    final overdueCount = taskVM.history.where((t) => !t.isCompleted).length;
    final totalCount = pendingCount + taskVM.history.length;

    final displayName = _userName.isNotEmpty ? _userName : 'Tu nombre';
    final hasImage = _imagePath.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Foto del perfil con opción de cambiar
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: colors.surface,
                    backgroundImage: hasImage
                        ? FileImage(File(_imagePath))
                        : null,
                    child: !hasImage
                    ? Icon(
                        Icons.person,
                        size: 56,
                        color: colors.onPrimaryContainer,
                      )
                    : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nombre del usuario con opción de editar
            GestureDetector(
              onTap: _editName,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: colors.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Estadísticas
            SectionTitleWidget(label: 'Estadísticas', color: colors.primary),
            const SizedBox(height: 16),

            // Tarjetas de estadísticas
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_rounded,
                    iconColor: colors.secondary,
                    label: 'Completadas',
                    value: '$completedCount',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_actions_rounded,
                    iconColor: colors.primary,
                    label: 'Pendientes',
                    value: '$pendingCount',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer_off_rounded,
                    iconColor: colors.tertiary,
                    label: 'Vencidas',
                    value: '$overdueCount',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bar_chart_rounded,
                    iconColor: colors.secondary,
                    label: 'Total',
                    value: '$totalCount',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Información de la cuenta
            SectionTitleWidget(label: 'Cuenta', color: colors.primary),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.outline),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline,
                    iconColor: colors.primary,
                    label: 'Nombre',
                    value: _userName.isNotEmpty ? _userName : 'No definido',
                  ),
                  Divider(height: 1, color: colors.outline),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    iconColor: colors.tertiary,
                    label: 'Miembro desde',
                    value: _memberSince,
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

// Widget auxiliar para el título de sección (estilo similar al SectionTitle del proyecto)
class SectionTitleWidget extends StatelessWidget {
  final String label;
  final Color color;

  const SectionTitleWidget({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Estructura de las tarjetas de información
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colors.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// Estructura de las filas de información
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface.withOpacity(0.5),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}