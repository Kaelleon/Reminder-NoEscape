import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/permission_service.dart';
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.tertiary,
        appBar: AppBar(
          title: const Text('Reminder: No Escape'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: colors.onSurface,
            actions: [
              Consumer<TaskViewModel>(
                builder: (context, taskVM, _) => IconButton(
                  icon: const Icon(Icons.share_rounded),
                  tooltip: 'Compartir tareas pendientes',
                  onPressed: () => ShareService.sharePendingTasks(taskVM.pending),
                ),
              ),
            ],
          bottom: TabBar(
            labelColor: colors.secondary,
            unselectedLabelColor: colors.tertiary,
            indicatorColor: colors.secondary,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task),
                    SizedBox(width: 8),
                    Text("Pendientes"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text("Historial"),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Capi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'capi@example.com',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.person_outline, color: colors.primary),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: colors.tertiary),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: colors.secondary),
                  title: const Text('Acerca de'),
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