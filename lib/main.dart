import 'package:flutter/material.dart';
import 'package:reminder_noescape/ui/screens/home_screen.dart';
import 'package:reminder_noescape/ui/screens/settings_screen.dart';
import 'package:reminder_noescape/ui/screens/about_screen.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/screens/task_detail_screen.dart';
import 'package:reminder_noescape/ui/screens/profile_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() 
{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
        '/profile' : (context) => const ProfileScreen(),
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
          primary: const Color.fromARGB(255, 255, 54, 54),
          secondary: const Color.fromARGB(255, 53, 63, 252),
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
