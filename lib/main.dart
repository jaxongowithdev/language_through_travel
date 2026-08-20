import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';
import 'services/tts_service.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final StorageService storage = await StorageService.create();
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(storage: storage, tts: TtsService()),
      child: const LanguageThroughTravelApp(),
    ),
  );
}

class LanguageThroughTravelApp extends StatelessWidget {
  const LanguageThroughTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Through Travel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: Consumer<AppState>(
        builder: (BuildContext context, AppState state, _) {
          return state.hasOnboarded
              ? const MainShell()
              : const OnboardingScreen();
        },
      ),
    );
  }
}
