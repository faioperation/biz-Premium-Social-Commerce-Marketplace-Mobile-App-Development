import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primarySubtle,
        secondary: AppColors.primaryLight,
        surface: AppColors.surfaceLight,
        surfaceContainerLow: AppColors.backgroundLight,
        surfaceContainerHighest: AppColors.hoverLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        outline: AppColors.borderLight,
        outlineVariant: AppColors.borderLight,
      ),

      textTheme: TextTheme(
        displayLarge:  AppTextStyles.h1.copyWith(color: AppColors.textPrimaryLight),
        displayMedium: AppTextStyles.h2.copyWith(color: AppColors.textPrimaryLight),
        displaySmall:  AppTextStyles.h3.copyWith(color: AppColors.textPrimaryLight),
        headlineMedium:AppTextStyles.h4.copyWith(color: AppColors.textPrimaryLight),
        titleLarge:    AppTextStyles.h5.copyWith(color: AppColors.textPrimaryLight),
        bodyLarge:     AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimaryLight),
        bodyMedium:    AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
        bodySmall:     AppTextStyles.bodySm.copyWith(color: AppColors.textSecondaryLight),
        labelLarge:    AppTextStyles.button.copyWith(color: Colors.white),
        labelSmall:    AppTextStyles.overline.copyWith(color: AppColors.textTertiaryLight),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
          side: const BorderSide(color: AppColors.borderLight),
        ),
        margin: EdgeInsets.zero,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textSecondaryLight),
        titleTextStyle: AppTextStyles.h5.copyWith(color: AppColors.textPrimaryLight),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          textStyle: AppTextStyles.button,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return Colors.white.withValues(alpha: 0.1);
            return null;
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryLight,
          side: const BorderSide(color: AppColors.borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          textStyle: AppTextStyles.button,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return AppColors.hoverLight;
            return null;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        hoverColor: AppColors.hoverLight,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiaryLight),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondaryLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        isDense: true,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.textSecondaryLight,
        size: 20,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.hoverLight,
        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textPrimaryLight),
        side: const BorderSide(color: AppColors.borderLight),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceLight,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
          side: const BorderSide(color: AppColors.borderLight),
        ),
        textStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 24,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXl),
        titleTextStyle: AppTextStyles.h4.copyWith(color: AppColors.textPrimaryLight),
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondaryLight),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimaryLight.withValues(alpha: 0.92),
          borderRadius: AppRadius.borderRadiusSm,
        ),
        textStyle: AppTextStyles.caption.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.borderLight),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primarySubtleDark,
        secondary: AppColors.primaryLight,
        surface: AppColors.surfaceDark,
        surfaceContainerLow: AppColors.backgroundDark,
        surfaceContainerHighest: AppColors.hoverDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.borderDark,
      ),

      textTheme: TextTheme(
        displayLarge:  AppTextStyles.h1.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTextStyles.h2.copyWith(color: AppColors.textPrimaryDark),
        displaySmall:  AppTextStyles.h3.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium:AppTextStyles.h4.copyWith(color: AppColors.textPrimaryDark),
        titleLarge:    AppTextStyles.h5.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge:     AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium:    AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
        bodySmall:     AppTextStyles.bodySm.copyWith(color: AppColors.textSecondaryDark),
        labelLarge:    AppTextStyles.button.copyWith(color: Colors.white),
        labelSmall:    AppTextStyles.overline.copyWith(color: AppColors.textTertiaryDark),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
          side: const BorderSide(color: AppColors.borderDark),
        ),
        margin: EdgeInsets.zero,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textSecondaryDark),
        titleTextStyle: AppTextStyles.h5.copyWith(color: AppColors.textPrimaryDark),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          textStyle: AppTextStyles.button,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return Colors.white.withValues(alpha: 0.1);
            return null;
          }),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          side: const BorderSide(color: AppColors.borderDark),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          textStyle: AppTextStyles.button,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return AppColors.hoverDark;
            return null;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryLight),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        hoverColor: AppColors.hoverDark,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiaryDark),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        isDense: true,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.textSecondaryDark,
        size: 20,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.hoverDark,
        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textPrimaryDark),
        side: const BorderSide(color: AppColors.borderDark),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.cardDark,
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
          side: const BorderSide(color: AppColors.borderDark),
        ),
        textStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardDark,
        elevation: 24,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusXl),
        titleTextStyle: AppTextStyles.h4.copyWith(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondaryDark),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppRadius.borderRadiusSm,
          border: Border.all(color: AppColors.borderDark),
        ),
        textStyle: AppTextStyles.caption.copyWith(color: AppColors.textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.borderDark),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),
    );
  }
}
