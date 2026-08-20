import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/learn_state.dart';
import '../theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'shell.dart';

/// Gốc của cây widget.
///
/// App chỉ có hai màn hình gốc: phần chào mừng lần đầu và khung bốn tab. Chủ đề
/// sáng hay tối do người dùng chọn trong Cá nhân, mặc định là tối.
class NoiNgayApp extends StatelessWidget {
  const NoiNgayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LearnState>(
      builder: (BuildContext context, LearnState state, _) {
        return MaterialApp(
          title: 'Nói Ngay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: state.onboarded ? const AppShell() : const WelcomeScreen(),
        );
      },
    );
  }
}
