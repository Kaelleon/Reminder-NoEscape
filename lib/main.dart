import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/models/preferences_view_model.dart';
import 'package:reminder_noescape/ui/screens/evaluation_screen.dart';
import 'package:reminder_noescape/ui/screens/home_screen.dart';
import 'package:reminder_noescape/ui/screens/settings_screen.dart';
import 'package:reminder_noescape/ui/screens/about_screen.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/screens/task_detail_screen.dart';
import 'package:reminder_noescape/ui/screens/profile_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:reminder_noescape/models/evaluation_view_model.dart';

void main() async 
{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await StorageService.init();
  
  runApp
  (
    MultiProvider
    (
      providers: 
      [
        ChangeNotifierProvider(create: (_) => PreferencesViewModel()),
        ChangeNotifierProvider(create: (_) => EvaluationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/evaluation' : (context) => const EvaluationScreen(),
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

        colorScheme: ColorScheme.dark
        (
          primary: const Color(0xFFE11D48),       //rojo
          secondary: const Color(0xFFFF6D00),     //naranja
          tertiary: const Color(0xFF3F3F46),      //gris
          surface: const Color(0xFF1C1C1F),       //superficies elevadas
          onPrimary: const Color(0xFFF8FAFC),     //texto sobre primary
          onSecondary: const Color(0xFFF8FAFC),   //texto sobre secondary
          onSurface: const Color(0xFFF8FAFC),     //texto general
          outline: const Color(0xFF3F3F46),       //bordes de contenedores
        ),
        scaffoldBackgroundColor: const Color(0xFF101012), //fondo por defecto
        textTheme: const TextTheme
        (
          bodyMedium: TextStyle
          (
            fontSize: 16.0, 
            fontWeight: FontWeight.w500,
          ),
        ),
        useMaterial3: true,
      ),
    );
  }
}
