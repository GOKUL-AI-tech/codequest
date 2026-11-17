import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Neon Palette
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonOrange = Color(0xFFFF6B00);
  static const Color neonYellow = Color(0xFFFFE600);
  static const Color neonBlue = Color(0xFF007BFF);
  static const Color neonGold = Color(0xFFFFD700);

  // Background Darks
  static const Color bgDark = Color(0xFF0A0E1A);
  static const Color bgDarkSecondary = Color(0xFF0F1629);
  static const Color bgCard = Color(0xFF141B2D);
  static const Color bgCardSecondary = Color(0xFF1A2235);
  static const Color bgSurface = Color(0xFF1E2A3F);

  // Text Colors
  static const Color textPrimary = Color(0xFFE8EAF6);
  static const Color textSecondary = Color(0xFF7B8AB8);
  static const Color textMuted = Color(0xFF4A5568);
  static const Color textAccent = Color(0xFF00F5FF);

  // Gradient Presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7B2FBE), Color(0xFF00B4DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberpunkGradient = LinearGradient(
    colors: [Color(0xFFBF00FF), Color(0xFF00F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00B09B), Color(0xFF39FF14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFFF006E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF0F1629)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Language Colors
  static const Color python = Color(0xFF3572A5);
  static const Color javascript = Color(0xFFF7DF1E);
  static const Color dart = Color(0xFF00B4AB);
  static const Color java = Color(0xFFB07219);
  static const Color cpp = Color(0xFFF34B7D);
  static const Color cLang = Color(0xFF555555);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD740);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF40C4FF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF0F4FF),
      colorScheme: const ColorScheme.light(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonPurple,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A2E),
      ),
      textTheme: _buildLightTextTheme(),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.neonCyan),
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A2E),
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E8FF), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F8FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE4F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE4F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.neonCyan,
        unselectedItemColor: Color(0xFF9AA5B4),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE0E8FF), thickness: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.neonCyan,
        linearTrackColor: Color(0xFFE0E8FF),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1A1A2E),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.orbitron(fontSize: 32, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A2E), letterSpacing: 2),
      displayMedium: GoogleFonts.orbitron(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E), letterSpacing: 1.5),
      headlineLarge: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
      headlineMedium: GoogleFonts.rajdhani(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
      titleLarge: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
      bodyLarge: GoogleFonts.rajdhani(fontSize: 16, color: const Color(0xFF2D3748), height: 1.6),
      bodyMedium: GoogleFonts.rajdhani(fontSize: 14, color: const Color(0xFF4A5568), height: 1.5),
      labelLarge: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E), letterSpacing: 1),
      labelSmall: GoogleFonts.shareTechMono(fontSize: 10, color: const Color(0xFF718096), letterSpacing: 0.5),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonPurple,
        tertiary: AppColors.neonGreen,
        surface: AppColors.bgCard,
        error: AppColors.error,
        onPrimary: AppColors.bgDark,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.bgDark,
      ),
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.neonCyan),
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A3550), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.bgDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonCyan,
          side: const BorderSide(color: AppColors.neonCyan, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCardSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3550)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3550)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgDarkSecondary,
        selectedItemColor: AppColors.neonCyan,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A3550),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.neonCyan,
        linearTrackColor: Color(0xFF2A3550),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgCardSecondary,
        selectedColor: AppColors.neonCyan.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        side: const BorderSide(color: Color(0xFF2A3550)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A3550)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgCardSecondary,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 2,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1.5,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1.2,
      ),
      headlineLarge: GoogleFonts.orbitron(
        fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1,
      ),
      headlineMedium: GoogleFonts.rajdhani(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.5,
      ),
      headlineSmall: GoogleFonts.rajdhani(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.rajdhani(
        fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.rajdhani(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.rajdhani(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.rajdhani(
        fontSize: 16, color: AppColors.textPrimary, height: 1.6,
      ),
      bodyMedium: GoogleFonts.rajdhani(
        fontSize: 14, color: AppColors.textSecondary, height: 1.5,
      ),
      bodySmall: GoogleFonts.rajdhani(
        fontSize: 12, color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.orbitron(
        fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: 1,
      ),
      labelMedium: GoogleFonts.shareTechMono(
        fontSize: 12, color: AppColors.textSecondary, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.shareTechMono(
        fontSize: 10, color: AppColors.textMuted, letterSpacing: 0.5,
      ),
    );
  }
}

// Custom Decorations
class AppDecorations {
  static BoxDecoration neonCard({Color glowColor = AppColors.neonCyan, double glowRadius = 8}) {
    return BoxDecoration(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: glowColor.withOpacity(0.3), width: 1),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.1),
          blurRadius: glowRadius,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration gradientCard(List<Color> colors) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static BoxDecoration glassMorphism({double opacity = 0.1}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    );
  }
}

// ─── Theme-aware color accessors ─────────────────────────────────────────────
// AppColors above are fixed compile-time constants (originally dark-only), so
// they can't react to the light/dark toggle. These context getters resolve the
// right color for whichever theme is currently active.
extension AppThemeColorsX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Screen background.
  Color get cqBg => Theme.of(this).scaffoldBackgroundColor;
  /// Secondary background (nav bars, side rails, section fills).
  Color get cqBgSecondary =>
      isDarkMode ? AppColors.bgDarkSecondary : Colors.white;
  /// Card surface.
  Color get cqCard => isDarkMode ? AppColors.bgCard : Colors.white;
  /// Secondary card / input fill surface.
  Color get cqCardSecondary =>
      isDarkMode ? AppColors.bgCardSecondary : const Color(0xFFF5F8FF);
  /// Subtle surface / border / track color.
  Color get cqSurface =>
      isDarkMode ? AppColors.bgSurface : const Color(0xFFE0E8FF);
  /// Primary text/icon color.
  Color get cqTextPrimary =>
      isDarkMode ? AppColors.textPrimary : const Color(0xFF1A1A2E);
  /// Secondary text/icon color.
  Color get cqTextSecondary =>
      isDarkMode ? AppColors.textSecondary : const Color(0xFF4A5568);
  /// Muted text/icon color (labels, unselected nav items, disabled state).
  Color get cqTextMuted =>
      isDarkMode ? AppColors.textMuted : const Color(0xFF718096);
}
