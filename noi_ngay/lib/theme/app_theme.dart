import 'package:flutter/material.dart';

import 'palette.dart';

/// Dựng [ThemeData] cho hai chế độ sáng/tối.
///
/// App mặc định chạy tối; chế độ sáng vẫn được cung cấp đầy đủ vì người dùng có
/// thể đổi trong Cá nhân → Cài đặt, và vì App Review thường bật cả hai để kiểm
/// tra độ tương phản.
class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: Palette.violet,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF2A1E5C),
      onPrimaryContainer: Color(0xFFE9E2FF),
      secondary: Palette.fuchsia,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF4A1436),
      onSecondaryContainer: Color(0xFFFFDDEF),
      tertiary: Palette.cyan,
      onTertiary: Color(0xFF04252B),
      error: Color(0xFFFF6B6B),
      onError: Color(0xFF3A0A0A),
      surface: Palette.night,
      onSurface: Color(0xFFF3F4FF),
      onSurfaceVariant: Color(0xFFA5AACB),
      outline: Color(0xFF3A4062),
      outlineVariant: Color(0xFF232845),
    );
    return _base(scheme, Palette.night);
  }

  static ThemeData light() {
    const ColorScheme scheme = ColorScheme.light(
      primary: Color(0xFF6D28D9),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFEDE4FF),
      onPrimaryContainer: Color(0xFF2A1160),
      secondary: Color(0xFFDB2777),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE0EF),
      onSecondaryContainer: Color(0xFF4F0426),
      tertiary: Color(0xFF0E7490),
      onTertiary: Colors.white,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: Palette.dawn,
      onSurface: Color(0xFF1A1730),
      onSurfaceVariant: Color(0xFF5B5878),
      outline: Color(0xFFCFC9E6),
      outlineVariant: Color(0xFFE6E2F5),
    );
    return _base(scheme, Palette.dawn);
  }

  static ThemeData _base(ColorScheme scheme, Color background) {
    final bool isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: scheme.onSurface,
        ),
      ),
      textTheme: _textTheme(scheme),
      // Thẻ trong app hầu hết là GlassCard tự vẽ; CardTheme chỉ để các widget
      // dựng sẵn của Material (Dialog, ExpansionTile…) không lệch nhịp.
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : scheme.outlineVariant,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          foregroundColor: scheme.onSurface,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.16)
                : scheme.outline,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white,
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : scheme.outlineVariant,
        ),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : scheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : scheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1B2143) : const Color(0xFF241F3D),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF141935) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF11162F) : Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : scheme.outlineVariant,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final Color ink = scheme.onSurface;
    final Color faint = scheme.onSurfaceVariant;
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
        color: ink,
      ),
      headlineSmall: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: ink),
      bodyMedium: TextStyle(fontSize: 14.5, height: 1.5, color: ink),
      bodySmall: TextStyle(fontSize: 13, height: 1.45, color: faint),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: faint,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: faint,
      ),
    );
  }
}
