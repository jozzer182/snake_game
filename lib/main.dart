import 'package:flutter/material.dart';
import 'services/preferences_service.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/scores_screen.dart';

/// Entry point of the Snake Flutter app
/// Initializes preferences service and sets up routing
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences service
  final preferencesService = PreferencesService();
  await preferencesService.init();

  runApp(SnakeFlutterApp(preferencesService: preferencesService));
}

/// Main application widget
/// Sets up Material 3 theme and navigation routes
class SnakeFlutterApp extends StatelessWidget {
  final PreferencesService preferencesService;

  const SnakeFlutterApp({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fidi - Snake Game',
      debugShowCheckedModeBanner: false,
      
      // Material 3 theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      
      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // Use system theme mode
      themeMode: ThemeMode.system,
      
      // Home route
      home: const HomeScreen(),
      
      // Named routes
      routes: {
        '/game': (context) => GameScreen(
              preferencesService: preferencesService,
            ),
        '/settings': (context) => SettingsScreen(
              preferencesService: preferencesService,
            ),
        '/scores': (context) => ScoresScreen(
              preferencesService: preferencesService,
            ),
      },
    );
  }
}

