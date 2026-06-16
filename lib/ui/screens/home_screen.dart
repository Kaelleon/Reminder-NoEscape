import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/permission_service.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/l10n/app_localizations.dart';
import 'package:reminder_noescape/models/task_view_model.dart';
import 'history_screen.dart';
import 'pending_tasks_screen.dart';
import 'package:reminder_noescape/core/services/share_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FlutterNativeSplash.remove();
      await PermissionService.requestAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.tertiary,
        appBar: AppBar(
          title: Text(l10n.tituloApp),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: colors.onSurface,
            actions: [
              Consumer<TaskViewModel>(
                builder: (context, taskVM, _) => IconButton(
                  icon: const Icon(Icons.share_rounded),
                  tooltip: l10n.compartir,
                  onPressed: () => ShareService.sharePendingTasks(taskVM.pending),
                ),
              ),
            ],
          bottom: TabBar(
            labelColor: colors.secondary,
            unselectedLabelColor: colors.tertiary,
            indicatorColor: colors.secondary,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.task),
                    const SizedBox(width: 8),
                    Text(l10n.pendientes),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 8),
                    Text(l10n.historial),
                  ],
                ),
              ),
            ],
          ),
        ),

        drawer: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: colors.surface),
                  child: Builder(
                    builder: (context) {
                      final savedName = StorageService.loadProfileName();
                      final savedImagePath = StorageService.loadProfileImagePath();
                      final displayName = savedName.isNotEmpty ? savedName : l10n.usuario;
                      final hasImage = savedImagePath.isNotEmpty;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: colors.surface,
                            backgroundImage: hasImage
                                ? FileImage(File(savedImagePath))
                                : null,
                            child: !hasImage
                            ? Icon(
                                Icons.person,
                                size: 56,
                                color: colors.onPrimaryContainer,
                              )
                            : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.person_outline, color: colors.primary),
                  title: Text(l10n.perfil),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: colors.tertiary),
                  title: Text(l10n.configuracion),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: colors.secondary),
                  title: Text(l10n.acercaDe),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
        ),

        body: const TabBarView(
          children: [
            PendingTasksScreen(),
            HistoryScreen(),
          ],
        ),
      ),
    );
  }
}