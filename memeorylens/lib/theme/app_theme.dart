import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color background = Color(0xFF0D0B14);
  static const Color surface = Color(0xFF161220);
  static const Color surfaceElevated = Color(0xFF1E1830);
  static const Color card = Color(0xFF1A1528);
  static const Color cardBorder = Color(0xFF2A2040);

  // Brand
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9D5CF6);
  static const Color primaryGradientStart = Color(0xFF7C3AED);
  static const Color primaryGradientEnd = Color(0xFFEC4899);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9B8FC0);
  static const Color textMuted = Color(0xFF5A5070);
  static const Color textHint = Color(0xFF3D3555);

  // Accent
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentYellow = Color(0xFFF59E0B);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentOrange = Color(0xFFF97316);

  // UI
  static const Color divider = Color(0xFF2A2040);
  static const Color inputBg = Color(0xFF1E1830);
  static const Color toggleActive = Color(0xFF7C3AED);
  static const Color badge = Color(0xFF7C3AED);

  // Tag colors
  static const Color tagEvent = Color(0xFF1D3557);
  static const Color tagPayment = Color(0xFF1A2E1A);
  static const Color tagTravel = Color(0xFF2D1B4E);
  static const Color tagInfo = Color(0xFF1E2A3A);
  static const Color tagNote = Color(0xFF3D2A00);
  static const Color tagHealth = Color(0xFF1A2E1A);
  static const Color tagShopping = Color(0xFF2D1B1B);
  static const Color tagBill = Color(0xFF1A2A3D);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryVertical = LinearGradient(
    colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient background = LinearGradient(
    colors: [Color(0xFF0D0B14), Color(0xFF130E20)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const RadialGradient orb = RadialGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899), Color(0xFF0D0B14)],
    stops: [0.0, 0.5, 1.0],
    radius: 0.8,
  );
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.3,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static const TextStyle amount = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle amountSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingLarge,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        space: 1,
        thickness: 1,
      ),
      fontFamily: 'Inter',
    );
  }
}