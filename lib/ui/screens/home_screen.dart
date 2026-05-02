import 'package:flutter/material.dart';
import 'pending_tasks_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget 
{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return DefaultTabController
    (
      length: 2,
      child: Scaffold
      (
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar
        (
          title: const Text("Reminder: No Escape"),
          actions: 
          [
            //menu de navegacion
            PopupMenuButton<String>
            (
              onSelected: (value)
              {
                switch (value)
                {
                  case 'settings':
                    Navigator.pushNamed(context, '/settings');
                    break;
                  case 'about':
                    Navigator.pushNamed(context, '/about');
                    break;
                }
              },

              itemBuilder: (context) => 
              [
                //navegar a configuracion
                const PopupMenuItem
                (
                  value: 'settings',
                  child: Row
                  (
                    children: 
                    [
                      Icon(Icons.settings),
                      SizedBox(width: 12),
                      Text("Configuración"),
                    ],
                  ),
                ),

                //navegar al about
                const PopupMenuItem
                (
                  value: 'about',
                  child: Row
                  (
                    children: 
                    [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Text("Acerca de"),
                    ],
                  ),
                ),
              ],
            ),
          ],

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