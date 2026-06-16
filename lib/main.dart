import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_noescape/core/services/storage_service.dart';
import 'package:reminder_noescape/models/preferences_view_model.dart';
import 'package:reminder_noescape/models/task_view_model.dart';
import 'package:reminder_noescape/ui/screens/evaluation_screen.dart';
import 'package:reminder_noescape/ui/screens/home_screen.dart';
import 'package:reminder_noescape/ui/screens/settings_screen.dart';
import 'package:reminder_noescape/ui/screens/about_screen.dart';
import 'package:reminder_noescape/models/task_model.dart';
import 'package:reminder_noescape/ui/screens/task_detail_screen.dart';
import 'package:reminder_noescape/ui/screens/profile_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:reminder_noescape/models/evaluation_view_model.dart';
import 'package:reminder_noescape/core/services/background_service.dart';
import 'package:reminder_noescape/core/services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder_noescape/l10n/app_localizations.dart';

void main() async 
{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await StorageService.init();
  await NotificationService.init();
  await BackgroundService.init();
  
  runApp
  (
    MultiProvider
    (
      providers: 
      [
        ChangeNotifierProvider(create: (_) => PreferencesViewModel()),
        ChangeNotifierProvider(create: (_) => EvaluationViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackgroundService.registerRescueTask();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final context = NotificationService.navigatorKey.currentContext;
      if (context != null) {
        context.read<TaskViewModel>().checkOverdueTasks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesViewModel>(
      builder: (context, prefs, _) {
        final isDark = prefs.theme == 'dark';
        final locale = prefs.language == 'en' ? const Locale('en') : const Locale('es');

        return MaterialApp(
          locale: locale,
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supported in supportedLocales) {
              if (supported.languageCode == locale?.languageCode) {
                return supported;
              }
            }
            return const Locale('es');
          },
          navigatorKey: NotificationService.navigatorKey,
          initialRoute: "/",
          routes: {
            '/': (context) => const HomeScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/about': (context) => const AboutScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/evaluation': (context) => const EvaluationScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/taskDetail') {
              final task = settings.arguments as Task;
              return MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              );
            }
            return null;
          },
          title: 'Reminder No Escape',
          theme: isDark ? _darkTheme() : _lightTheme(),
        );
      },
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFE11D48),
        secondary: const Color(0xFFFF6D00),
        tertiary: const Color(0xFF3F3F46),
        surface: const Color(0xFF1C1C1F),
        onPrimary: const Color(0xFFF8FAFC),
        onSecondary: const Color(0xFFF8FAFC),
        onSurface: const Color(0xFFF8FAFC),
        outline: const Color(0xFF3F3F46),
      ),
      scaffoldBackgroundColor: const Color(0xFF101012),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFE11D48),
        secondary: const Color(0xFFFF6D00),
        tertiary: const Color(0xFF6B7280),
        surface: const Color(0xFFF3F4F6),
        onPrimary: const Color(0xFFFFFFFF),
        onSecondary: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF1F2937),
        outline: const Color(0xFFD1D5DB),
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      useMaterial3: true,
    );
  }
}