import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'pending_tasks_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeScreen extends StatelessWidget
{
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context)
  {
    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      FlutterNativeSplash.remove();
    });

    final colors = Theme.of(context).colorScheme;
    
    return DefaultTabController
    (
      length: 2,
      child: Scaffold
      (
        backgroundColor: colors.tertiary,
        appBar: AppBar
        (
          title: const Text('Reminder: No Escape'),

          //navegacion entre pendientes e historial
          bottom: const TabBar
          (
            tabs: 
            [
              Tab
              (
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Icon(Icons.task), 
                    SizedBox(width: 8), 
                    Text("Pendientes"),
                  ],
                ),
              ),
              
              Tab
              (
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Icon(Icons.history), 
                    SizedBox(width: 8), 
                    Text("Historial"),
                  ],
                ),
              ),
            ],
          ),
        ),

        //drawer de navegacion
        drawer: Drawer
        (
          child: SafeArea
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                //encabezado del drawer
                DrawerHeader
                (
                  decoration: BoxDecoration(color: colors.secondary),
                  child: Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: 
                    [
                      CircleAvatar
                      (
                        radius: 32,
                        backgroundImage: AssetImage('assets/images/profile.png')
                      ),
                      const SizedBox(width: 14),
                      const Expanded
                      (
                        child: Column
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: 
                          [
                            Text
                            (
                              'Capi',
                              style: TextStyle
                              (
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),

                            Text
                            (
                              'capi@example.com',
                              style: TextStyle
                              (
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //perfil
                ListTile
                (
                  leading: Icon(Icons.person_outline, color: Color(0xFF5C6BC0)),
                  title: const Text('Perfil'),
                  onTap: ()
                  {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),

                const Divider(),

                //configuracion
                ListTile
                (
                  leading: Icon(Icons.settings_outlined, color: Color(0xFF546E7A)),
                  title: const Text('Configuración'),
                  onTap: ()
                  {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),

                //about
                ListTile
                (
                  leading: Icon(Icons.info_outline, color: Color(0xFF26A69A)),
                  title: const Text('Acerca de'),
                  onTap: ()
                  {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
        ),

        body: const TabBarView
        (
          children: 
          [
            PendingTasksScreen(),
            HistoryScreen(),
          ],
        ),
      ),
    );
  }
}