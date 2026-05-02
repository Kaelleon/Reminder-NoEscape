import 'package:flutter/material.dart';
import 'package:reminder_noescape/ui/screens/home_screen.dart';
import 'package:reminder_noescape/ui/screens/settings_screen.dart';
import 'package:reminder_noescape/ui/screens/about_screen.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/screens/task_detail_screen.dart';

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      initialRoute: "/",

      //rutas de pantallas normales
      routes: 
      {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
      },

      //rutas de pantallas dinamicas
      onGenerateRoute: (settings)
      {
        if (settings.name == '/taskDetail')
        {
          final task = settings.arguments as Task;
          return MaterialPageRoute
          (
            builder: (context) => TaskDetailScreen(task: task),
          );
        }
        return null;
      },

      title: 'Reminder No Escape',
      theme: ThemeData
      (

        colorScheme: ColorScheme.fromSeed
        (
          seedColor: const Color.fromARGB(255, 32, 87, 255),
          primary: const Color.fromARGB(255, 212, 57, 57),
          secondary: const Color.fromARGB(255, 69, 255, 221),
          tertiary: const Color.fromARGB(255, 169, 216, 255),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), //fondo por defecto
        textTheme: const TextTheme
        (
          bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        useMaterial3: true,
      ),
    );
  }
}
