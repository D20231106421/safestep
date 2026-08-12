import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOUR TOKENS
// ─────────────────────────────────────────────
abstract class AppColors {
  // Dark Backgrounds
  static const canvas         = Color(0xFF0B0F19); // Deep Obsidian Slate
  static const surface        = Color(0xFF0F172A); // Elevated Surface
  static const cardFill       = Color(0xFF131C2E); // Card / Glass Container
  static const surfaceBorder  = Color(0xFF1E293B); // Subtle border

  // Light Backgrounds
  static const lightCanvas        = Color(0xFFF6FCF9);
  static const lightSurface       = Colors.white;
  static const lightCardFill      = Color(0xC8FFFFFF); // 78% opacity white frosted fill
  static const lightSurfaceBorder = Color(0xFFE6F4F0);

  // Primary Accent — Emerald / Teal
  static const emerald        = Color(0xFF10B981);
  static const emeraldDeep    = Color(0xFF0D9488);
  static const emeraldGlow    = Color(0x4010B981); // 25% opacity glow
  static const emeraldBadgeBg = Color(0x1A10B981); // 10% opacity badge bg
  static const emeraldMuted   = Color(0xFF34D399);
  static const lightEmeraldMuted = Color(0xFF047857);

  // Secondary Accent — Indigo / Cyan
  static const indigo         = Color(0xFF6366F1);
  static const indigoGlow     = Color(0x0F6366F1);
  static const indigoBadgeBg  = Color(0x1A6366F1);
  static const cyan           = Color(0xFF06B6D4);

  // Alert Accents
  static const amber          = Color(0xFFF59E0B);
  static const amberBadgeBg   = Color(0x1AF59E0B);
  static const amberBorder    = Color(0x33F59E0B);
  static const rose           = Color(0xFFEF4444);
  static const roseBadgeBg    = Color(0x1AEF4444);
  static const roseBorder     = Color(0x33EF4444);

  // Typography — Dark Mode
  static const textPrimary    = Color(0xFFF8FAFC); // Slate-50
  static const textSecondary  = Color(0xFF94A3B8); // Slate-400
  static const textMuted      = Color(0xFF64748B); // Slate-500

  // Typography — Light Mode
  static const lightTextPrimary   = Color(0xFF0F172A); // Slate-900
  static const lightTextSecondary = Color(0xFF475569); // Slate-600
  static const lightTextMuted     = Color(0xFF94A3B8); // Slate-400

  // Focus border
  static const focusBorder    = Color(0x8010B981); // emerald 50%

  // Card glass white border
  static const glassBorder    = Color(0x14FFFFFF); // white 8%

  // ── Context-aware getters ─────────────────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color canvasOf(BuildContext context) =>
      isDark(context) ? canvas : lightCanvas;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? surface : lightSurface;

  static Color cardFillOf(BuildContext context) =>
      isDark(context) ? cardFill.withValues(alpha: 0.7) : lightCardFill;

  static Color surfaceBorderOf(BuildContext context) =>
      isDark(context) ? glassBorder : lightSurfaceBorder;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? textPrimary : lightTextPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? textSecondary : lightTextSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? textMuted : lightTextMuted;
}

// ─────────────────────────────────────────────
//  TEXT STYLE TOKENS
// ─────────────────────────────────────────────
abstract class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 22, fontWeight: FontWeight.w800,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, height: 1.5,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 8.5, fontWeight: FontWeight.w800,
    color: AppColors.textMuted,
    letterSpacing: 0.8,
  );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 9, fontWeight: FontWeight.w600,
    color: AppColors.textMuted, letterSpacing: 0.3,
  );
}

// ─────────────────────────────────────────────
//  THEME DATA
// ─────────────────────────────────────────────
abstract class AppTheme {
  static ThemeData buildTheme() => buildDarkTheme();

  static ThemeData buildDarkTheme() {
    final base = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.canvas,

      colorScheme: const ColorScheme.dark(
        primary:    AppColors.emerald,
        secondary:  AppColors.indigo,
        surface:    AppColors.surface,
        error:      AppColors.rose,
        onPrimary:  Colors.white,
        onSurface:  AppColors.textPrimary,
      ),

      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 32, fontWeight: FontWeight.w900,
          color: AppColors.textPrimary, letterSpacing: -0.5,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 22, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 12, color: AppColors.textSecondary, height: 1.5,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 10, color: AppColors.textSecondary, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 8.5, fontWeight: FontWeight.w800,
          color: AppColors.textMuted, letterSpacing: 0.8,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.3,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.surfaceBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emerald;
          return AppColors.surfaceBorder;
        }),
      ),

      dividerColor: AppColors.surfaceBorder,

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary, fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textMuted, fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  static ThemeData buildLightTheme() {
    final base = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightCanvas,

      colorScheme: const ColorScheme.light(
        primary:    AppColors.emerald,
        secondary:  AppColors.indigo,
        surface:    AppColors.lightSurface,
        error:      AppColors.rose,
        onPrimary:  Colors.white,
        onSurface:  AppColors.lightTextPrimary,
      ),

      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 32, fontWeight: FontWeight.w900,
          color: AppColors.lightTextPrimary, letterSpacing: -0.5,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 22, fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 12, color: AppColors.lightTextSecondary, height: 1.5,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 10, color: AppColors.lightTextSecondary, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          fontSize: 8.5, fontWeight: FontWeight.w800,
          color: AppColors.lightTextMuted, letterSpacing: 0.8,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightCanvas,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.lightTextPrimary,
          fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.3,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextSecondary,
          side: const BorderSide(color: AppColors.lightSurfaceBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.lightTextMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emerald;
          return AppColors.lightSurfaceBorder;
        }),
      ),

      dividerColor: AppColors.lightSurfaceBorder,

      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightSurfaceBorder),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white, fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.lightTextMuted, fontSize: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightSurfaceBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.rose, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
